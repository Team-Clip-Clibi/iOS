//
//  GetInMeetingUseCase.swift
//  OneThing
//
//  Created by 오현식 on 7/18/25.
//

import Foundation

struct GetInMeetingUseCase {
    private let repository: MatchingRepository
    
    init(repository: MatchingRepository = MatchingRepository()) {
        self.repository = repository
    }
    
    func execute(
        type matchingType: MatchingType,
        with matchingId: String
    ) async throws -> InMeetingInfo {
        return try await self.repository.matchingProgressInfo(
            type: matchingType,
            with: matchingId
        ).inMeetingInfo
    }
}
