//
//  GetMatchingSummaryUseCase.swift
//  OneThing
//
//  Created by 오현식 on 5/9/25.
//

import Foundation

struct GetMatchingSummaryUseCase {
    private let repository: MatchingRepository
    
    init(repository: MatchingRepository = MatchingRepository()) {
        self.repository = repository
    }
    
    func execute() async throws -> [MatchingSummaryInfo] {
        return try await self.repository.meetingSummaries().toDomain()
    }
}
