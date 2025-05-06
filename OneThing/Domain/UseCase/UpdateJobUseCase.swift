//
//  UpdateJobUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 5/4/25.
//

import Foundation

struct UpdateJobUseCase {
    private let repository: UserInfoRepository
    
    init(repository: UserInfoRepository = UserInfoRepository()) {
        self.repository = repository
    }
    
    func execute(jobs: [JobType]) async throws -> Bool {
        let statusCode = try await repository.usersJob(with: JobDTO(jobList: jobs)).statusCode
        return statusCode == 204
    }
}
