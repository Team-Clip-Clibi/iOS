//
//  GetProfileInfoUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 5/3/25.
//

import Foundation

struct GetProfileInfoUseCase {
    private let repository: UserInfoRepository
    
    init(repository: UserInfoRepository = UserInfoRepository()) {
        self.repository = repository
    }
    
    func execute() async throws -> UserProfileInfo {
        return try await repository.usersProfile()
    }
}
