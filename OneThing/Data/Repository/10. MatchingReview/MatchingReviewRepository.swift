//
//  MatchingReviewRepository.swift
//  OneThing
//
//  Created by 윤동주 on 5/3/25.
//

import Foundation

struct MatchingReviewRepository {
    
    private let networkService = OTNetworkService()
    
    // MARK: - GET
    
    /// 작성해야할 후기 팝업 조회 API
    func reviews() async throws -> NeedReviewDTO {
        let endpoint = EndPoint(
            path: "/reviews",
            method: .post,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.get(endpoint: endpoint)
    }
    
    /// 매칭 참여자 리스트 조회 API
    func reviewsParticipants(with id: String, type: MatchingType) async throws -> ParticipantDTO {
        let endpoint = EndPoint(
            path: "/reviews/\(id)/\(type.rawValue)/participants",
            method: .post,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.get(endpoint: endpoint)
    }
    
    
    // MARK: - POST
    
    /// 매칭 후기 작성 API
    func matchingReview(_ dto: MatchingReviewDTO, with id: String, type: MatchingType) async throws -> Int {
        let endpoint = EndPoint(
            path: "/reviews/\(id)/\(type.rawValue)",
            method: .post,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.post(endpoint: endpoint, body: dto).statusCode
    }
    
    // MARK: - PATCH
    
    /// 작성해야할 후기 팝업 다음에 작성하기 API
    func reviewsPostpone(with id: String, type: MatchingType) async throws -> Int {
        let endpoint = EndPoint(
            path: "/reviews/\(id)/\(type.rawValue)/postpone",
            method: .post,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.patch(endpoint: endpoint).statusCode
    }
}
