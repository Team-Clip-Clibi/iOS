//
//  MeetingReviewAssembler.swift
//  OneThing
//
//  Created by 오현식 on 8/10/25.
//

import Foundation

final class MeetingReviewAssembler: OTAssemblerable {
    
    let nicknames: [String]
    let matchingId: String
    let matchingType: MatchingType
    
    init(_ nicknames: [String], with matchingId: String, type matchingType: MatchingType) {
        self.nicknames = nicknames
        self.matchingId = matchingId
        self.matchingType = matchingType
    }
    
    func assemble(container: OTDIContainerable) {
        container.register(MatchingReviewRepository.self) { _ in
            MatchingReviewRepository()
        }
        container.register(SubmitMeetingReviewUseCase.self) { resolver in
            SubmitMeetingReviewUseCase(repository: resolver.resolve(MatchingReviewRepository.self))
        }
        
        container.register(MeetingReviewStore.self) { resolver in
            MeetingReviewStore(
                submitMeetingReviewUseCase: resolver.resolve(SubmitMeetingReviewUseCase.self),
                initalInfo: .init(
                    nicknames: self.nicknames,
                    matchingId: self.matchingId,
                    matchingtype: self.matchingType
                )
            )
        }
    }
}
