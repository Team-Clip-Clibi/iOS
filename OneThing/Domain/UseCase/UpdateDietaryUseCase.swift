//
//  UpdateDietaryUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 5/6/25.
//

import Foundation

struct UpdateDietaryUseCase {
    private let repository: UserInfoRepository
    
    init(repository: UserInfoRepository = UserInfoRepository()) {
        self.repository = repository
    }
    
    func execute(dietaryOption: String) async throws -> Bool {
        let statusCode = try await repository.usersDietary(with: DietaryDTO(dietaryOption: dietaryOption)).statusCode
        return statusCode == 204
    }
}
