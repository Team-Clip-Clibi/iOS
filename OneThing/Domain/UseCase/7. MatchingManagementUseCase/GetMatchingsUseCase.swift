//
//  GetMatchingsUseCase.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct GetMatchingsUseCase {
    private let repository: MatchingManagementRepository
    
    init(repository: MatchingManagementRepository = MatchingManagementRepository()) {
        self.repository = repository
    }
    
    // 모임 상세보기 조회
    func matchingsDetail(
        type matchingType: MatchingType,
        with matchingId: String
    ) async throws -> MatchingDetailInfo {
        return try await self.repository.matchingsDetail(
            type: matchingType,
            with: matchingId
        ).matchingDetailInfo
    }
    
    // 모임 리스트 조회
    func matchings() async throws -> [MatchingInfo] {
        return try await self.repository.matchings().matchingInfos
    }
    
    // 모임 리스트 조회 + 필터
    func matchings(_ request: MatchingRequest) async throws -> [MatchingInfo] {
        let dto = MatchingRequestDTO(matchingRequest: request)
        return try await self.repository.matchings(dto).matchingInfos
    }
    
    // 진행중인 모임 정보 조회
    func matchingsProgress(
        type matchingType: MatchingType,
        with matchingId: String
    ) async throws -> MatchingProgressInfo {
        return try await self.repository.matchingsProgress(
            type: matchingType,
            with: matchingId
        ).matchingProgressInfo
    }
}
