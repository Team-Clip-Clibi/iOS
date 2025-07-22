//
//  GetRandomDuplicateCheckUseCase.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct GetRandomDuplicateCheckUseCase {
    private let repository: RandomMatchingRepository
    
    init(repository: RandomMatchingRepository = RandomMatchingRepository()) {
        self.repository = repository
    }
    
    func execute() async throws -> RandomMatchingDuplicateCheckInfo {
        return try await self.repository.randomDuplicateCheck().randomMatchingDuplicateCheckInfo
    }
}
