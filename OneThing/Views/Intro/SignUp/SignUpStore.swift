//
//  SignUpStore.swift
//  OneThing
//
//  Created by 오현식 on 8/6/25.
//

import Foundation
import SwiftUI

@Observable
class SignUpStore: OTStore {
    
    enum Text {
        static let termsOfService: String = "서비스 이용약관"
        static let privacyPolicy: String = "개인정보 수집/이용 동의"
        static let MarketingPolicy: String = "맞춤형 광고 및 마케팅 수집 동의"
    }
    
    enum Action: OTAction {
        case updateToAcceptTerms([Int])
        case updateToDeniedTerms([Int])
        case banners
        case loginWithKakao
        case signUpWithKakao
        case loginWithApple
        case updatePhoneNumber(String)
        case updateUsername(String)
        case checkNicknameAvailable(String)
        case updateNickname(String)
        case updateDetail(gender: String, birth: String, city: City?, county: County?)
    }
    
    enum Process: OTProcess {
        case updateToAcceptTerms([Term])
        case updateToDeniedTerms([Term])
        case banners([LoginBannerInfo])
        case loginWithKakao(LoginResult?)
        case signUpWithKakao(Bool)
        case loginWithApple(Bool)
        case updatePhoneNumber(Bool)
        case updateUsername(Bool)
        case updateNicknameAvailable(Bool)
        case updateNickname(Bool)
        case updateDetail(Bool)
    }
    
    struct State: OTState {
        fileprivate(set) var terms: [Term]
        fileprivate(set) var banners: [LoginBannerInfo]
        fileprivate(set) var loginResultByKakao: LoginResult?
        fileprivate(set) var isSuccessSignUpByKakao: Bool
        fileprivate(set) var isLoginByApple: Bool
        fileprivate(set) var isPhoneNumberUpdated: Bool
        fileprivate(set) var isUsernameUpdated: Bool
        fileprivate(set) var isNicknameValid: Bool
        fileprivate(set) var isNicknameUpdated: Bool
        fileprivate(set) var isDetailUpdated: Bool
        
        var isAllTermsAccepted: Bool {
            return self.terms.filter { $0.isAccepted == false }.isEmpty
        }
        var isRequiredTermsAccepted: Bool {
            return self.terms.filter { $0.isRequired }.allSatisfy { $0.isAccepted }
        }
    }
    var state: State
    
    private let socialLoginUseCase: SocialLoginUseCase
    private let updateUserNameUseCase: UpdateUserNameUseCase
    private let updateNicknameUseCase: UpdateNicknameUseCase
    private let updatePhoneNumberUseCase: UpdatePhoneNumberUseCase
    private let getNicknameAvailableUseCase: GetNicknameAvailableUseCase
    private let getBannerUseCase: GetBannerUseCase
    
    init(
        socialLoginUseCase: SocialLoginUseCase,
        updateUserNameUseCase: UpdateUserNameUseCase,
        updateNicknameUseCase: UpdateNicknameUseCase,
        updatePhoneNumberUseCase: UpdatePhoneNumberUseCase,
        getNicknameAvailableUseCase: GetNicknameAvailableUseCase,
        getBannerUseCase: GetBannerUseCase
    ) {
        
        self.state = State(
            terms: [
                Term(
                    title: Text.termsOfService,
                    isRequired: true,
                    isAccepted: false
                ),
                Term(
                    title: Text.privacyPolicy,
                    isRequired: true,
                    isAccepted: false
                ),
                Term(
                    title: Text.MarketingPolicy,
                    isRequired: false,
                    isAccepted: false
                )
            ],
            banners: [],
            loginResultByKakao: nil,
            isSuccessSignUpByKakao: false,
            isLoginByApple: false,
            isPhoneNumberUpdated: false,
            isUsernameUpdated: false,
            isNicknameValid: false,
            isNicknameUpdated: false,
            isDetailUpdated: false
        )
        
        self.socialLoginUseCase = socialLoginUseCase
        self.updateUserNameUseCase = updateUserNameUseCase
        self.updateNicknameUseCase = updateNicknameUseCase
        self.updatePhoneNumberUseCase = updatePhoneNumberUseCase
        self.getNicknameAvailableUseCase = getNicknameAvailableUseCase
        self.getBannerUseCase = getBannerUseCase
    }
    
    func process(_ action: Action) async -> OTProcessResult<Process> {
        switch action {
        case let .updateToAcceptTerms(selectedIndex):
            return await self.updateToAcceptTerms(selectedIndex)
        case let .updateToDeniedTerms(selectedIndex):
            return await self.updateToDeniedTerms(selectedIndex)
        case .banners:
            return await self.banners()
        case .loginWithKakao:
            return await self.loginWithKakao()
        case .signUpWithKakao:
            return await self.signUpWithKakao()
        case .loginWithApple:
            return await self.loginWithApple()
        case let .updatePhoneNumber(phoneNumber):
            return await self.updatePhoneNumber(phoneNumber)
        case let .updateUsername(username):
            return await self.updateUsername(username)
        case let .checkNicknameAvailable(nickname):
            return await self.updateNicknameAvailable(nickname)
        case let .updateNickname(nickname):
            return await self.updateNickname(nickname)
        case let .updateDetail(gender, birth, city, county):
            return await self.updateDetail(gender: gender, birth: birth, city: city, county: county)
        }
    }
    
    func reduce(state: State, process: Process) -> State {
        var newState = state
        switch process {
        case let .updateToAcceptTerms(terms):
            newState.terms = terms
        case let .updateToDeniedTerms(terms):
            newState.terms = terms
        case let .banners(banners):
            newState.banners = banners
        case let .loginWithKakao(loginResultByKakao):
            newState.loginResultByKakao = loginResultByKakao
        case let .signUpWithKakao(isSuccessSignUpByKakao):
            newState.isSuccessSignUpByKakao = isSuccessSignUpByKakao
        case let .loginWithApple(isLoginByApple):
            newState.isLoginByApple = isLoginByApple
        case let .updatePhoneNumber(isPhoneNumberUpdated):
            newState.isPhoneNumberUpdated = isPhoneNumberUpdated
        case let .updateUsername(isUsernameUpdated):
            newState.isUsernameUpdated = isUsernameUpdated
        case let .updateNicknameAvailable(isNicknameValid):
            newState.isNicknameValid = isNicknameValid
        case let .updateNickname(isNicknameUpdated):
            newState.isNicknameUpdated = isNicknameUpdated
        case let .updateDetail(isDetailUpdated):
            newState.isDetailUpdated = isDetailUpdated
        }
        return newState
    }
}

private extension SignUpStore {
    
    func updateToAcceptTerms(_ selectedIndex: [Int]) async -> OTProcessResult<Process> {
        guard selectedIndex.contains(where: { $0 == 0 || $0 == 1 || $0 == 2 }) else { return .none }
    
        selectedIndex.forEach {
            self.state.terms[$0].isAccepted = true
        }
        return .single(.updateToAcceptTerms(self.state.terms))
    }
    
    func updateToDeniedTerms(_ selectedIndex: [Int]) async -> OTProcessResult<Process> {
        guard selectedIndex.contains(where: { $0 == 0 || $0 == 1 || $0 == 2 }) else { return .none }
        
        selectedIndex.forEach {
            self.state.terms[$0].isAccepted = false
        }
        return .single(.updateToDeniedTerms(self.state.terms))
    }
    
    func banners() async -> OTProcessResult<Process> {
        do {
            let banners: [LoginBannerInfo] = try await self.getBannerUseCase.execute(with: .login)
            
            return .single(.banners(banners))
        } catch {
            return .single(.banners([]))
        }
    }
    
    func loginWithKakao() async -> OTProcessResult<Process> {
        do {
            let loginResultByKakao = try await self.socialLoginUseCase.loginWithKakao()
            
            return .single(.loginWithKakao(loginResultByKakao))
        } catch {
            return .single(.loginWithKakao(nil))
        }
    }
    
    func signUpWithKakao() async -> OTProcessResult<Process> {
        do {
            let isSuccessSignUpByKakao = try await self.socialLoginUseCase.signUpWithKakao(
                serviceTerm: self.state.terms[0].isAccepted,
                privateTerm: self.state.terms[1].isAccepted,
                marketingTerm: self.state.terms[2].isAccepted
            )
            
            return .single(.signUpWithKakao(isSuccessSignUpByKakao))
        } catch {
            return .single(.signUpWithKakao(false))
        }
    }
    
    func loginWithApple() async -> OTProcessResult<Process> {
        return .single(.loginWithApple(false))
    }
    
    func updatePhoneNumber(_ phoneNumber: String) async -> OTProcessResult<Process> {
        do {
            let isPhoneNumberUpdated = try await self.updatePhoneNumberUseCase.execute(
                phoneNumber: phoneNumber
            )
            
            return .single(.updatePhoneNumber(isPhoneNumberUpdated))
        } catch {
            return .single(.updatePhoneNumber(false))
        }
    }
    
    func updateUsername(_ username: String) async -> OTProcessResult<Process> {
        do {
            let isUsernameUpdated = try await self.updateUserNameUseCase.execute(with: username)
            
            return .single(.updateUsername(isUsernameUpdated))
        } catch {
            return .single(.updateUsername(false))
        }
    }
    
    func updateNicknameAvailable(_ nickname: String) async -> OTProcessResult<Process> {
        do {
            let isNicknameValid = try await self.getNicknameAvailableUseCase.execute(with: nickname)
            
            return .single(.updateNicknameAvailable(isNicknameValid))
        } catch {
            return .single(.updateNicknameAvailable(false))
        }
    }
    
    func updateNickname(_ nickname: String) async -> OTProcessResult<Process> {
        do {
            let isNicknameUpdated = try await self.updateNicknameUseCase.execute(nickname: nickname)
            
            return .single(.updateNickname(isNicknameUpdated))
        } catch {
            return .single(.updateNickname(false))
        }
    }
    
    func updateDetail(
        gender: String,
        birth: String,
        city: City?,
        county: County?
    ) async -> OTProcessResult<Process> {
        guard let city = city, let county = county else { return .none }
        
        do {
            let isDetailUpdated = try await self.socialLoginUseCase.updateDetail(
                gender: gender,
                birth: birth,
                city: city.englishCode,
                county: county.code
            )
            
            return .single(.updateDetail(isDetailUpdated))
        } catch {
            return .single(.updateDetail(false))
        }
    }
}

struct Card: Equatable {
    var imageURL: String
    var mainText: String
    var subText: String
}

struct Term: Identifiable, Equatable {
    var id = UUID()
    var title: String
    var isRequired: Bool
    var isAccepted: Bool
}

enum NicknameRule {
    case nothing
    case normal
    case tooShort
    case tooLong
    case invalidCharacter
    case duplicate
    case available
    case confirmCompleted
    
    var message: String {
        switch self {
        case .nothing:
            return "국문과 영문만 입력 가능합니다. (2 ~ 8자)"
        case .normal:
            return "국문과 영문만 입력 가능합니다. (2 ~ 8자)"
        case .tooShort:
            return "*2자 이상 입력해주세요."
        case .tooLong:
            return "*최대 8자까지 가능해요."
        case .invalidCharacter:
            return "*닉네임은 숫자/특수문자를 사용할 수 없습니다."
        case .duplicate:
            return "이미 사용 중인 닉네임입니다."
        case .available:
            return "사용 가능한 닉네임입니다."
        case .confirmCompleted:
            return "사용 가능한 닉네임입니다."
        }
    }
    
    var textColor: Color {
        switch self {
        case .available, .confirmCompleted:
            return .gray800
        case .normal:
            return .gray600
        case .nothing:
            return .gray600
        default:
            return .red100
        }
    }
}
