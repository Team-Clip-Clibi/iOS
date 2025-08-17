//
//  MyPageAssembler.swift
//  OneThing
//
//  Created by 오현식 on 8/10/25.
//

import Foundation

final class MyPageEditAssembler: OTAssemblerable {
    
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
        
        container.register(UserInfoRepository.self) { _ in
            UserInfoRepository()
        }
        container.register(GetProfileInfoUseCase.self) { resolver in
            GetProfileInfoUseCase(repository: resolver.resolve(UserInfoRepository.self))
        }
        container.register(GetJobUseCase.self) { resolver in
            GetJobUseCase(repository: resolver.resolve(UserInfoRepository.self))
        }
        container.register(GetRelationshipUseCase.self) { resolver in
            GetRelationshipUseCase(repository: resolver.resolve(UserInfoRepository.self))
        }
        container.register(GetDietaryUseCase.self) { resolver in
            GetDietaryUseCase(repository: resolver.resolve(UserInfoRepository.self))
        }
        container.register(GetLanguageUseCase.self) { resolver in
            GetLanguageUseCase(repository: resolver.resolve(UserInfoRepository.self))
        }
        container.register(GetNicknameAvailableUseCase.self) { resolver in
            GetNicknameAvailableUseCase(repository: resolver.resolve(UserInfoRepository.self))
        }
        container.register(UpdateNicknameUseCase.self) { resolver in
            UpdateNicknameUseCase(repository: resolver.resolve(UserInfoRepository.self))
        }
        container.register(UpdateJobUseCase.self) { resolver in
            UpdateJobUseCase(repository: resolver.resolve(UserInfoRepository.self))
        }
        container.register(UpdateRelationshipUseCase.self) { resolver in
            UpdateRelationshipUseCase(repository: resolver.resolve(UserInfoRepository.self))
        }
        container.register(UpdateDietaryUseCase.self) { resolver in
            UpdateDietaryUseCase(repository: resolver.resolve(UserInfoRepository.self))
        }
        container.register(UpdateLanguageUseCase.self) { resolver in
            UpdateLanguageUseCase(repository: resolver.resolve(UserInfoRepository.self))
        }
        
        container.register(MyPageEditStore.self) { resolver in
            MyPageEditStore(
                socialLoginUseCase: resolver.resolve(SocialLoginUseCase.self),
                getProfileInfoUseCase: resolver.resolve(GetProfileInfoUseCase.self),
                getJobUseCase: resolver.resolve(GetJobUseCase.self),
                getRelationshipUseCase: resolver.resolve(GetRelationshipUseCase.self),
                getDietaryUseCase: resolver.resolve(GetDietaryUseCase.self),
                getLanguageUseCase: resolver.resolve(GetLanguageUseCase.self),
                getNicknameAvailableUseCase: resolver.resolve(GetNicknameAvailableUseCase.self),
                updateNicknameUseCase: resolver.resolve(UpdateNicknameUseCase.self),
                updateJobUseCase: resolver.resolve(UpdateJobUseCase.self),
                updateRelationshipUseCase: resolver.resolve(UpdateRelationshipUseCase.self),
                updateDietaryUseCase: resolver.resolve(UpdateDietaryUseCase.self),
                updateLanguageUseCase: resolver.resolve(UpdateLanguageUseCase.self)
            )
        }
    }
}
