//
//  RandomMatchingRepository.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct RandomMatchingRepository {
    
    private let networkService = OTNetworkService()
    
    
    // MARK: - GET
    
    func randomDuplicateCheck() async throws -> RandomMatchingDuplicateCheckDTO {
        let endpoint = EndPoint(
            path: "/random/duplicate-check",
            method: .get,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.get(endpoint: endpoint)
    }
    
    
    /// 모임 내역 전체 호출
    func matchings() async throws -> [MatchingProgressInfo] {
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
    
    /// 모임 내역 요약
    func matchings(matchingStatus: String,
                   lastMeetingTime: String
    ) async throws -> MatchingProgressInfo {
        let endpoint = EndPoint(
            path: "/matchings/matchingStatus=\(matchingStatus)&lastMeetingTime=\(lastMeetingTime)",
            method: .get,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.get(endpoint: endpoint)
    }
    
    /// 모임 안내문 조희
    /// lastMeetingTime ex) "2025-07-06T07:53:33.776Z"
    func matchingsNotices(lastMeetingTime: String) async throws -> MatchingNoticeDTO {
        let endpoint = EndPoint(
            path: "/matchings/order/lastMeetingTime=\(lastMeetingTime)",
            method: .get,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.get(endpoint: endpoint)
    }
    
    // MARK: - PATCH
    
    func updateRandomOrdersCapacity(with matchingId: String) async throws -> HTTPURLResponse {
        let endpoint = EndPoint(
            path: "/random/orders/\(matchingId)/capacity",
            method: .patch,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.patch(endpoint: endpoint)
    }
    
    
    // MARK: - POST
    
    func submitRandomOrders(
        _ dto: RandomOrderRequestDTO
    ) async throws -> (RandomOrderResponseDTO, HTTPURLResponse) {
        let endpoint = EndPoint(
            path: "/random/orders",
            method: .post,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.post(endpoint: endpoint, body: dto)
    }
}
