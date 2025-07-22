//
//  UpdateRandomOrdersCapacityUseCase.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct UpdateRandomOrdersCapacityUseCase {
    private let repository: RandomMatchingRepository
    
    init(repository: RandomMatchingRepository = RandomMatchingRepository()) {
        self.repository = repository
    }
    
    func execute(with matchingId: String) async throws -> Int {
        let statusCode = try await self.repository.updateRandomOrdersCapacity(with: matchingId).statusCode
        return statusCode
    }
}
