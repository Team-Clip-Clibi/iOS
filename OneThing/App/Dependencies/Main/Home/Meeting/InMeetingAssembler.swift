//
//  InMeetingAssembler.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import Foundation

final class InMeetingAssembler: OTAssemblerable {
    
    let matchingId: String
    let matchingType: MatchingType
    
    init(with matchingId: String, type matchingType: MatchingType) {
        self.matchingId = matchingId
        self.matchingType = matchingType
    }
    
    func assemble(container: OTDIContainerable) {
        container.register(MatchingManagementRepository.self) { _ in
            MatchingManagementRepository()
        }
        container.register(GetMatchingsUseCase.self) { resolver in
            GetMatchingsUseCase(repository: resolver.resolve(MatchingManagementRepository.self))
        }
        
        container.register(MatchingManagementRepository.self) { _ in
            MatchingManagementRepository()
        }
        container.register(UpdateMatchingsStatusUseCase.self) { resolver in
            UpdateMatchingsStatusUseCase(repository: resolver.resolve(MatchingManagementRepository.self))
        }
        
        container.register(InMeetingStore.self) { resolver in
            InMeetingStore(
                getMatchingsUseCase: resolver.resolve(GetMatchingsUseCase.self),
                updateMatchingsStatusUseCase: resolver.resolve(UpdateMatchingsStatusUseCase.self),
                matchingId: self.matchingId,
                matchingType: self.matchingType
            )
        }
    }
}
