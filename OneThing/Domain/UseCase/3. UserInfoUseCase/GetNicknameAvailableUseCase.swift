//
//  GetNicknameAvailableUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 7/27/25.
//

import Foundation

struct GetNicknameAvailableUseCase {
    private let repository: UserInfoRepository
    
    init(repository: UserInfoRepository = UserInfoRepository()) {
        self.repository = repository
    }
    
    func execute(with nickname: String) async throws -> Bool {
        return try await repository.usersNicknameAvailable(with: NicknameDTO(nickname: nickname))
    }
}
