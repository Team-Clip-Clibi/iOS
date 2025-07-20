//
//  MatchingReviewRepository.swift
//  OneThing
//
//  Created by 윤동주 on 5/3/25.
//

import Foundation

struct MatchingReviewRepository {
    
    private let networkService = OTNetworkService()
    
    // MARK: - POST
    
    func meetingReview(_ dto: MeetingReviewDTO, with id: String, type: MatchingType) async throws -> Int {
        let endpoint = EndPoint(
            path: "/reviews/\(id)/\(type.rawValue)",
            method: .post,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.post(endpoint: endpoint, body: dto).0
    }
}
