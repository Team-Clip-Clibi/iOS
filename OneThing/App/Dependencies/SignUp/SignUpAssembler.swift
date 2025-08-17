//
//  AuthAssembler.swift
//  OneThing
//
//  Created by 오현식 on 8/6/25.
//

import Foundation

final class SignUpAssembler: OTAssemblerable {
    
    func assemble(container: OTDIContainerable) {
        container.register(AuthRepository.self) { _ in
            AuthRepository()
        }
        container.register(UserInfoRepository.self) { _ in
            UserInfoRepository()
        }
        container.register(SocialLoginUseCase.self) { resolver in
            SocialLoginUseCase(
                authRepository: resolver.resolve(AuthRepository.self),
                userInfoRepository: resolver.resolve(UserInfoRepository.self),
                sessionStore: resolver.resolve(SessionStoring.self)
            )
        }
        
        container.register(UpdateUserNameUseCase.self) { resolver in
            UpdateUserNameUseCase(repository: resolver.resolve(UserInfoRepository.self))
        }
        
        container.register(UpdateNicknameUseCase.self) { resolver in
            UpdateNicknameUseCase(repository: resolver.resolve(UserInfoRepository.self))
        }
        
        container.register(UpdatePhoneNumberUseCase.self) { resolver in
            UpdatePhoneNumberUseCase(repository: resolver.resolve(UserInfoRepository.self))
        }
        
        container.register(GetNicknameAvailableUseCase.self) { resolver in
            GetNicknameAvailableUseCase(repository: resolver.resolve(UserInfoRepository.self))
        }
        
        container.register(DisplayContentsRepository.self) { _ in
            DisplayContentsRepository()
        }
        container.register(GetBannerUseCase.self) { resolver in
            GetBannerUseCase(repository: resolver.resolve(DisplayContentsRepository.self))
        }
        
        container.register(SignUpStore.self) { resolver in
            SignUpStore(
                socialLoginUseCase: resolver.resolve(SocialLoginUseCase.self),
                updateUserNameUseCase: resolver.resolve(UpdateUserNameUseCase.self),
                updateNicknameUseCase: resolver.resolve(UpdateNicknameUseCase.self),
                updatePhoneNumberUseCase: resolver.resolve(UpdatePhoneNumberUseCase.self),
                getNicknameAvailableUseCase: resolver.resolve(GetNicknameAvailableUseCase.self),
                getBannerUseCase: resolver.resolve(GetBannerUseCase.self)
            )
        }
    }
}
