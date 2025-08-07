//
//  GetReviewsParticipantUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 7/27/25.
//

import Foundation

struct GetReviewsParticipantUseCase {
    private let repository: MatchingReviewRepository
    
    init(repository: MatchingReviewRepository = MatchingReviewRepository()) {
        self.repository = repository
    }
    
    func execute(id: String, type: MatchingType) async throws -> [ParticipantInfo] {
        return try await self.repository.reviewsParticipants(with: id, type: type).participantInfos
    }
}
