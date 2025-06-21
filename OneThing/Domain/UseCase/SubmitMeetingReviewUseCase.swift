//
//  SubmitMeetingReviewUseCase.swift
//  OneThing
//
//  Created by 오현식 on 6/20/25.
//

import Foundation

struct SubmitMeetingReviewUseCase {
    private let repository: MatchingReviewRepository
    
    init(repository: MatchingReviewRepository = MatchingReviewRepository()) {
        self.repository = repository
    }
    
    func execute(
        mood: MeetingReviewInfo,
        positivePoints: String,
        negativePoints: String,
        reviewContent: String,
        noShowMembers: String,
        isMemberAllAttended: Bool,
        matchingId: String,
        matchingType: MatchingType
    ) async throws -> Bool {
        let statusCode = try await self.repository.meetingReview(
            MeetingReviewDTO(
                mood: mood,
                positivePoints: positivePoints,
                negativePoints: negativePoints,
                reviewContent: reviewContent,
                noShowMembers: noShowMembers,
                isMemberAllAttended: isMemberAllAttended
            ),
            with: matchingId,
            type: matchingType
        )
        
        return statusCode == 200
    }
}
