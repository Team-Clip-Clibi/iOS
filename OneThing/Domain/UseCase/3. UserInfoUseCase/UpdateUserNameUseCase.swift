//
//  UpdateUserNameUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 7/27/25.
//

import Foundation

struct UpdateUserNameUseCase {
    private let repository: UserInfoRepository
    
    init(repository: UserInfoRepository = UserInfoRepository()) {
        self.repository = repository
    }
    
    func execute(with userName: String) async throws -> Bool {
        let statusCode = try await repository.usersName(with: UserNameDTO(userName: userName)).statusCode
        return statusCode == 204
    }
}
