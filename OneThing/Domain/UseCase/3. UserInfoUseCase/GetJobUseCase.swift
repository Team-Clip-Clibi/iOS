//
//  GetJobUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 5/4/25.
//

import Foundation

struct GetJobUseCase {
    private let repository: UserInfoRepository
    
    init(repository: UserInfoRepository = UserInfoRepository()) {
        self.repository = repository
    }
    
    func execute() async throws -> JobType? {
        let result = try await repository.usersJob()
        
        return result.job
    }
}
