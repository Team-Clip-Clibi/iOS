//
//  SocialLoginUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 4/1/25.
//

import Foundation

import AuthenticationServices
import FirebaseMessaging
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser


import SwiftUI

class SocialLoginUseCase {
    
    private var idToken: String?
    
    private let authRepository: AuthRepository
    private let userInfoRepository: UserInfoRepository
    
    private let sessionStore: SessionStoring
    
    @AppStorage("socialId") var socialId: String = ""
    @AppStorage("platform") var platform: String = ""
    @AppStorage("firebaseToken") var firebaseToken: String = ""
    
    init(
        authRepository: AuthRepository = AuthRepository(),
        userInfoRepository: UserInfoRepository = UserInfoRepository(),
        sessionStore: SessionStoring = UserDefaultsSessionStore()
    ) {
        self.authRepository = authRepository
        self.userInfoRepository = userInfoRepository
        self.sessionStore = sessionStore
    }
    
    /// Kakao 로그인을 진행합니다.
    func loginWithKakao() async throws -> LoginResult {
        
        guard let idToken = await self.getKakaoIdToken() else {
            throw NetworkError.invalidIdToken
        }
        guard let socialId = await extractKakaoSocialID(idToken) else {
            throw NetworkError.invalidSocialId
        }
        guard let firebaseToken = await getFCMToken() else {
            throw NetworkError.invalidFCMToken
        }
        
        UserDefaults.standard.set(socialId, forKey: "socialId")
        UserDefaults.standard.set("KAKAO", forKey: "platform")
        UserDefaults.standard.set(firebaseToken, forKey: "firebaseToken")
        
        let signInDTO = SignInDTO(
//            socialId: "".randomString(length: 10),
            socialId: socialId,
            platform: platform,
            osVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String,
            firebaseToken: firebaseToken,
            isAllowNotify: true
        )
        dump(signInDTO)
        do {
            let response = try await authRepository.usersSignIn(with: signInDTO)
            
            TokenManager.shared.accessToken = response.accessToken
            TokenManager.shared.refreshToken = response.refreshToken
            return .success
        } catch let error as NetworkError {
            switch error {
            case .invalidHttpStatusCode(let code) where code == 400:
                return .needToSignUp
            default:
                print("\(#function) - 네트워크 에러 - \(error)")
                return .needToSignUp
            }
        } catch {
            print("\(#function) - 기타 에러 - \(error)")
            return .otherError
        }
    }
    
    func signUpWithKakao(
        serviceTerm: Bool,
        privateTerm: Bool,
        marketingTerm: Bool
    ) async throws {
        let signUpDTO = SignUpDTO(
            servicePermission: serviceTerm,
            privatePermission: privateTerm,
            marketingPermission: marketingTerm,
//            socialId: "".randomString(length: 10),
            socialId: socialId,
            platform: "KAKAO",
            osVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String,
            firebaseToken: firebaseToken,
            isAllowNotify: true
        )
        
        do {
            let response = try await authRepository.usersSignup(with: signUpDTO)
            dump(response)
            TokenManager.shared.accessToken = response.accessToken
            TokenManager.shared.refreshToken = response.refreshToken
        } catch {
            print(error)
        }
    }
    
    func updatePhoneNumber(phoneNumber: String) async throws -> Bool {
        let statusCode = try await userInfoRepository.usersPhone(with: UpdatePhoneNumberDTO(phoneNumber: phoneNumber)).statusCode
        return statusCode == 204
    }
    
    func updateUserName(userName: String) async throws -> Bool {
        let statusCode = try await userInfoRepository.usersName(with: UpdateNameDTO(userName: userName)).statusCode
        return statusCode == 204
    }
    
    func getNickNameAvailableStatus(nickname: String) async throws -> Bool {
        return try await userInfoRepository.usersNicknameAvailable(with: UpdateNicknameDTO(nickname: nickname))
    }
    
    func updateDetail(gender: String, birth: String, city: String, county: String) async throws -> Bool {
        let statusCode = try await userInfoRepository.usersDetail(
            with: UpdateUserDetailInfoDTO(
                gender: gender,
                birth: birth,
                city: city,
                county: county
            )
        ).statusCode
        return statusCode == 204
    }
    
    func deleteAccount() async throws -> Bool {
        if try await authRepository.usersMe() {
            UserDefaults.standard.removeObject(forKey: "socialId")
            UserDefaults.standard.removeObject(forKey: "platform")
            UserDefaults.standard.removeObject(forKey: "firebaseToken")
            return true
        } else {
            return false
        }
    }
    
    /// Kakao 소셜 로그인을 통해 idToken을 받아옵니다.
    @MainActor
    private func getKakaoIdToken() async -> String? {
        if UserApi.isKakaoTalkLoginAvailable() {
            return await withCheckedContinuation { continuation in
                UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                    if let error = error {
                        print(error)
                        continuation.resume(returning: nil)
                    } else {
                        dump(oauthToken)
                        continuation.resume(returning: oauthToken?.idToken)
                    }
                }
            }
        } else {
            return await withCheckedContinuation { continuation in
                UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                    if let error = error {
                        print(error)
                        continuation.resume(returning: nil)
                    } else {
                        dump(oauthToken)
                        continuation.resume(returning: oauthToken?.idToken)
                    }
                }
            }
        }
    }
    
    /// Kakao idToken으로부터 소셜 아이디를 추출합니다.
    private func extractKakaoSocialID(_ idToken: String) async -> String? {
        
        let segments = idToken.split(separator: ".")
        guard segments.count >= 2 else { return nil }
        
        let payloadSegment = String(segments[1])
        
        var base64 = payloadSegment
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let remainder = base64.count % 4
        if remainder > 0 {
            base64 += String(repeating: "=", count: 4 - remainder)
        }
        
        guard let payloadData = Data(base64Encoded: base64) else {
            return nil
        }
        
        guard let jsonObject = try? JSONSerialization.jsonObject(with: payloadData, options: []),
              let payload = jsonObject as? [String: Any] else {
            return nil
        }
        
        return payload["sub"] as? String
    }
    
    /// FCM 토큰을 가져옵니다.
    @MainActor
    private func getFCMToken() async -> String? {
        await withCheckedContinuation { continuation in
            Messaging.messaging().token { token, error in
                if let error = error {
                    print("\(#function) - FCM Token 생성 실패 - \(error.localizedDescription)")
                    continuation.resume(returning: nil)
                } else {
                    continuation.resume(returning: token)
                }
            }
        }
    }
}

enum LoginResult {
    case success
    case needToSignUp
    case networkError
    case otherError
}
