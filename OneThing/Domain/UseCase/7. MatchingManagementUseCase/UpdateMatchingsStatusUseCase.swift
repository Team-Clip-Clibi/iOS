//
//  UpdateMatchingsStatusUseCase.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct UpdateMatchingsStatusUseCase {
    private let repository: MatchingManagementRepository
    
    init(repository: MatchingManagementRepository = MatchingManagementRepository()) {
        self.repository = repository
    }
    
    // 모임 신청 취소
    func matchingsCanceled(
        type matchingType: MatchingType,
        with matchingId: String
    ) async throws -> Bool {
        let statusCode = try await self.repository.updateMatchingsCanceled(
            type: matchingType,
            with: matchingId
        ).statusCode
        return statusCode == 204
    }
    
    // 모임 완료
    func matchingsEnded(
        type matchingType: MatchingType,
        with matchingId: String
    ) async throws -> Bool {
        let statusCode = try await self.repository.updateMatchingsEnded(
            type: matchingType,
            with: matchingId
        ).statusCode
        return statusCode == 204
    }
}
