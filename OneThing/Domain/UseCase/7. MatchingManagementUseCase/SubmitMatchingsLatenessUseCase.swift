//
//  SubmitMatchingsLatenessUseCase.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct SubmitMatchingsLatenessUseCase {
    private let repository: MatchingManagementRepository
    
    init(repository: MatchingManagementRepository = MatchingManagementRepository()) {
        self.repository = repository
    }
    
    func execute(
        type matchingType: MatchingType,
        with matchingId: String,
        _ lateMinutes: Int
    ) async throws -> Bool {
        let dto = LateMinutesRequestDTO(lateMinutes: lateMinutes)
        let statusCode = try await self.repository.submitMatchingsLateness(
            type: matchingType,
            with: matchingId,
            dto
        ).statusCode
        return statusCode == 204
    }
}
