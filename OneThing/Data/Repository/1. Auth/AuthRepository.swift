//
//  AuthRepository.swift
//  OneThing
//
//  Created by 윤동주 on 4/3/25.
//

import Foundation

struct AuthRepository {
    
    // MARK: - Properties

    private let networkService = OTNetworkService()
    
    // MARK: - POST
    
    /// Access Token 재발급 API
    func usersTokens(with dto: RefreshTokenDTO) async throws -> AccessTokenDTO {
        let endpoint = EndPoint(
            path: "/users/tokens",
            method: .post,
            headers: [
                "Content-Type": "application/json"
            ]
        )
        
        return try await networkService.post(endpoint: endpoint, body: dto).0
    }
    
    /// 회원가입 API
    func usersSignup(with dto: SignUpDTO) async throws -> SignUpResponse {
        let endpoint = EndPoint(
            path: "/users/signup",
            method: .post,
            headers: [
                "Content-Type": "application/json"
            ]
        )
        
        return try await networkService.post(endpoint: endpoint, body: dto).0
    }
    
    /// 로그인 API
    func usersSignIn(with dto: SignInDTO) async throws -> SignInResponse {
        let endpoint = EndPoint(
            path: "/users/signin",
            method: .post,
            headers: [
                "Content-Type": "application/json"
            ]
        )
        
        return try await networkService.post(endpoint: endpoint, body: dto).0
    }
    
    // MARK: - GET
    
    /// 번호로 가입된 계정 조회 API
    func usersPhoneNumberInfo(phoneNumber: String) async throws -> UserInfoDTO {
        let endpoint = EndPoint(
            path: "/users/\(phoneNumber)/info",
            method: .get,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await networkService.get(endpoint: endpoint)
    }
    
    // MARK: - DELETE
    
    /// 회원 탈퇴 API
    func usersMe() async throws -> Bool {
        let endpoint = EndPoint(
            path: "/users/me",
            method: .delete,
            headers: [
                "Authorization": "Bearer \(TokenManager.shared.refreshToken)"
            ]
        )
        
        return try await networkService.delete(endpoint: endpoint).statusCode == 204
    }
}
