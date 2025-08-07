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
    
    func execute(job: JobType) async throws -> Bool {
        let statusCode = try await repository.usersJob(with: JobDTO(job: job)).statusCode
        return statusCode == 204
    }
}
