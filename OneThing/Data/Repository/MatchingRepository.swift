//
//  MatchingRepository.swift
//  OneThing
//
//  Created by 윤동주 on 5/3/25.
//

import Foundation

struct MatchingRepository {
    
    private let networkService = OTNetworkService()
    
    // MARK: - GET
    
    func meetingSummaries() async throws -> MatchingSummaryDTO {
        let endpoint = EndPoint(
            path: "/matchings/summaries",
            method: .get,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.get(endpoint: endpoint)
    }
    
    // 모임 진행상태 조회
    func meetingProgress() async throws -> MatchingProgressStatusDto {
        let endpoint = EndPoint(
            path: "/matchings",
            method: .get,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.get(endpoint: endpoint)
    }
    
    // 시작된 모임 정보 조회
    func matchingProgressInfo(
        type matchingType: MatchingType,
        with matchingId: String
    ) async throws -> InMeetingDTO {
        let endpoint = EndPoint(
            path: "/matchings/\(matchingType.rawValue)/\(matchingId)/progress",
            method: .get,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.get(endpoint: endpoint)
    }
    
    // MARK: - PATCH
    
    // 진행중인 모임 종료
    func meetingEnded(type matchingType: MatchingType, with matchingId: String) async throws -> HTTPURLResponse {
        let endpoint = EndPoint(
            path: "/matchings/\(matchingType.rawValue)/\(matchingId)/progress-status/end",
            method: .patch,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.patch(endpoint: endpoint)
    }
}
