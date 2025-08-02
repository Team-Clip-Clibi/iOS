//
//  MatchingManagementRepository.swift
//  OneThing
//
//  Created by 윤동주 on 5/3/25.
//

import Foundation

struct MatchingManagementRepository {
    
    private let networkService = OTNetworkService()
    
    
    // MARK: - GET
    
    // 모임 상세 조회
    func matchingsDetail(
        type matchingType: MatchingType,
        with matchingId: String
    ) async throws -> MatchingDetailDTO {
        let endpoint = EndPoint(
            path: "/matchings/\(matchingType.rawValue)/\(matchingId)",
            method: .get,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.get(endpoint: endpoint)
    }
    
    // 모임 리스트 조회
    func matchings() async throws -> MatchingDTO {
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
    // 모임 리스트 조회 + 필터
    func matchings(_ dto: MatchingRequestDTO) async throws -> MatchingDTO {
        let endpoint = EndPoint(
            path: "/matchings",
            method: .get,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.get(endpoint: endpoint, body: dto)
    }
    
    // 진행중인 모임 정보 조회
    func matchingsProgress(
        type matchingType: MatchingType,
        with matchingId: String
    ) async throws -> MatchingProgressDTO {
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
    
    // 매칭된 모임 정보 요약 조회
    func matchingsSummaries() async throws -> MatchingSummaryDTO {
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
    
    // 모임 현황 조회
    func matchingsOverview() async throws -> MatchingOverviewDTO {
        let endpoint = EndPoint(
            path: "/matchings/overview",
            method: .get,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.get(endpoint: endpoint)
    }
    
    // 모임 안내문 조회
    func matchingsNotices() async throws -> MatchingNoticeDTO {
        let endpoint = EndPoint(
            path: "/matchings/notices",
            method: .get,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.get(endpoint: endpoint)
    }
    // 모임 안내문 조회
    func matchingsNotices(with lastMeetingTime: Date) async throws -> MatchingNoticeDTO {
        let endpoint = EndPoint(
            path: "/matchings/notices",
            method: .get,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.get(endpoint: endpoint, body: lastMeetingTime)
    }
    
    
    // MARK: - PATCH
    
    // 모임 신청 취소
    func updateMatchingsCanceled(
        type matchingType: MatchingType,
        with matchingId: String
    ) async throws -> HTTPURLResponse {
        let endpoint = EndPoint(
            path: "/matchings/\(matchingType.rawValue)/\(matchingId)",
            method: .patch,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.patch(endpoint: endpoint)
    }
    
    // 진행중인 모임 정보 읽음 상태로 변경
    func updateMatchingsEnded(
        type matchingType: MatchingType,
        with matchingId: String
    ) async throws -> HTTPURLResponse {
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
    
    
    // MARK: - POST
    
    // 모임 지각 상태 업데이트 및 FCM 알림 전송
    func submitMatchingsLateness(
        type matchingType: MatchingType,
        with matchingId: String,
        _ dto: LateMinutesRequestDTO
    ) async throws -> HTTPURLResponse {
        let endpoint = EndPoint(
            path: "/matchings/\(matchingType.rawValue)/\(matchingId)",
            method: .post,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.post(endpoint: endpoint, body: dto)
    }
}
