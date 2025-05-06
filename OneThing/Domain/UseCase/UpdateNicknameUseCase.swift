//
//  UpdateNicknameUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 5/3/25.
//

import Foundation

struct UpdateNicknameUseCase {
    private let repository: UserInfoRepository
    
    init(repository: UserInfoRepository = UserInfoRepository()) {
        self.repository = repository
    }
    
    func execute(nickname: String) async throws -> Bool {
        let statusCode = try await repository.usersNickname(with: UpdateNicknameDTO(nickname: nickname)).statusCode
        return statusCode == 204
    }
}
