//
//  GetMatchingsExistsUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 7/31/25.
//

import Foundation

struct GetMatchingsExistsUseCase {
    private let repository: UserInfoRepository
    
    init(repository: UserInfoRepository = UserInfoRepository()) {
        self.repository = repository
    }
    
    func execute(with nickname: String) async throws -> Bool {
        return try await repository.usersMatchingsExists()
    }
}
