//
//  InitialMatchingAssembler.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import Foundation

final class InitialMatchingAssembler: OTAssemblerable {
    
    let willPushedMatchingType: MatchingType
    
    init(with willPushedMatchingType: MatchingType) {
        self.willPushedMatchingType = willPushedMatchingType
    }
    
    func assemble(container: OTDIContainerable) {
        container.register(UserInfoRepository.self) { _ in
            UserInfoRepository()
        }
        container.register(UpdateJobUseCase.self) { resolver in
            UpdateJobUseCase(repository: resolver.resolve(UserInfoRepository.self))
        }
        container.register(UpdateDietaryUseCase.self) { resolver in
            UpdateDietaryUseCase(repository: resolver.resolve(UserInfoRepository.self))
        }
        container.register(UpdateLanguageUseCase.self) { resolver in
            UpdateLanguageUseCase(repository: resolver.resolve(UserInfoRepository.self))
        }
        
        container.register(InitialMatchingStore.self) { resolver in
            InitialMatchingStore(
                willPushedMatchingType: self.willPushedMatchingType,
                updateJobUseCase: resolver.resolve(UpdateJobUseCase.self),
                updateDietaryUseCase: resolver.resolve(UpdateDietaryUseCase.self),
                updateLanguageUseCase: resolver.resolve(UpdateLanguageUseCase.self)
            )
        }
    }
}
