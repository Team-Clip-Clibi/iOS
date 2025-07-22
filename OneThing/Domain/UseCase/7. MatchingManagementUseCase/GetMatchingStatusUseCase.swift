//
//  GetMatchingStatusUseCase.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct GetMatchingStatusUseCase {
    private let repository: MatchingManagementRepository
    
    init(repository: MatchingManagementRepository = MatchingManagementRepository()) {
        self.repository = repository
    }
    
    // 매칭된 모임 정보 요약 조회
    func matchingsSummaries() async throws -> (onethings: [MatchingSummaryInfo], randoms: [MatchingSummaryInfo]) {
        let response =  try await self.repository.matchingsSummaries()
        return (response.oneThingMatchings, response.randomMatchings)
    }
    
    // 모임 형환 조회
    func matchingsOverview() async throws -> MatchingOverviewInfo {
        return try await self.repository.matchingsOverview().matchingOverviewInfo
    }
}
