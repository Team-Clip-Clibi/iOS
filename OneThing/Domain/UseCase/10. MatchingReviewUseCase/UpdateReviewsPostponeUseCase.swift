//
//  UpdateReviewsPostponeUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 7/27/25.
//

import Foundation

struct UpdateReviewsPostponeUseCase {
    private let repository: MatchingReviewRepository
    
    init(repository: MatchingReviewRepository = MatchingReviewRepository()) {
        self.repository = repository
    }
    
    func execute(id: String, type: MatchingType) async throws -> Bool {
        return try await repository.reviewsPostpone(with: id, type: type) == 200
    }
}
