//
//  SignUpViewModel.swift
//  OneThing
//
//  Created by 윤동주 on 3/23/25.
//

import SwiftUI

@Observable
class SignUpViewModel {
    
    // MARK: - Properties
    
    // TODO: - 추후 Mock Repository 분리 필요
    var banners: [LoginBannerInfo] = []
    
    var terms: [Term] = [
        Term(
            title: "서비스 이용약관",
            isRequired: true,
            isAccepted: false
        ),
        Term(
            title: "개인정보 수집/이용 동의",
            isRequired: true,
            isAccepted: false
        ),
        Term(
            title: "맞춤형 광고 및 마케팅 수집 동의",
            isRequired: false,
            isAccepted: false
        )
    ]
    
    var isAllTermsAccepted: Bool {
        for term in terms {
            if !term.isAccepted {
                return false
            }
        }
        return true
    }
    
    var isRequiredTermsAccepted: Bool {
        for term in terms {
            if term.isRequired && !term.isAccepted {
                return false
            }
        }
        return true
    }
    
    private var socialLoginUseCase: SocialLoginUseCase
    private var updateNicknameUseCase: UpdateNicknameUseCase
    private let getBannerUseCase: GetBannerUseCase
    
    // MARK: - Initializer

    init(
        socialLoginUseCase: SocialLoginUseCase = SocialLoginUseCase(),
        updateNicknameUseCase: UpdateNicknameUseCase = UpdateNicknameUseCase(),
        getBannerUseCase: GetBannerUseCase = GetBannerUseCase()
    ) {
        self.socialLoginUseCase = socialLoginUseCase
        self.updateNicknameUseCase = updateNicknameUseCase
        self.getBannerUseCase = getBannerUseCase
    }
    
    // MARK: - Functions
    
    func loginWithKakao() async throws -> LoginResult {
        try await socialLoginUseCase.loginWithKakao()
    }
    
    func signUpWithKakao() async throws {
        do {
            try await socialLoginUseCase.signUpWithKakao(
                serviceTerm: terms[0].isAccepted,
                privateTerm: terms[1].isAccepted,
                marketingTerm: terms[2].isAccepted
            )
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func fetchBanner() async throws {
        let result: [LoginBannerInfo] = try await getBannerUseCase.execute(with: BannerInfoType.login)
        if !result.isEmpty {
            self.banners = try await getBannerUseCase.execute(with: BannerInfoType.login)
        }
    }
    
    func updatePhoneNumber(phoneNumber: String) async throws -> Bool {
        return try await socialLoginUseCase.updatePhoneNumber(phoneNumber: phoneNumber)
    }
    
    func updateName(userName: String) async throws -> Bool {
        return try await socialLoginUseCase.updateUserName(userName: userName)
    }
    
    func isNicknameAvailable(nickname: String) async throws -> Bool {
        return try await socialLoginUseCase.getNickNameAvailableStatus(nickname: nickname)
    }
    
    func updateNickname(nickname: String) async throws -> Bool {
        return try await updateNicknameUseCase.execute(nickname: nickname)
    }
    
    func updateDetail(gender: String, birth: String, city: City?, county: County?) async throws -> Bool {
        guard let city = city else {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
        
        guard let county = county else {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
        
        return try await socialLoginUseCase.updateDetail(gender: gender, birth: birth, city: city.englishCode, county: county.code)
    }
    
    func loginWithApple() -> Bool {
        return false
    }
    
    func setAllTermsAccepted() {
        for index in terms.indices {
            terms[index].isAccepted = true
        }
    }
    
    func setAllTermsDenied() {
        for index in terms.indices {
            terms[index].isAccepted = false
        }
    }
}


struct Card {
    var imageURL: String
    var mainText: String
    var subText: String
}

struct Term: Identifiable {
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
