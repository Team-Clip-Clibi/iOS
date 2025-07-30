//
//  GetDietaryUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 5/6/25.
//

import Foundation

struct GetDietaryUseCase {
    private let repository: UserInfoRepository
    
    init(repository: UserInfoRepository = UserInfoRepository()) {
        self.repository = repository
    }
    
    func execute() async throws -> String {
        let result = try await repository.usersDietary()
    
        return result.dietaryOption ?? ""
    }
}
