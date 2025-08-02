//
//  GetNeedReviewUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 7/27/25.
//

import Foundation

struct GetNeedReviewUseCase {
    private let repository: MatchingReviewRepository
    
    init(repository: MatchingReviewRepository = MatchingReviewRepository()) {
        self.repository = repository
    }
    
    func execute() async throws -> [NeedReviewInfo] {
        return try await self.repository.reviews().needReviewInfos
    }
}
