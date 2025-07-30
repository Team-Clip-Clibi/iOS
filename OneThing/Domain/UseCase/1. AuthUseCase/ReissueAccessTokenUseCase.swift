//
//  ReissueAccessTokenUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 7/31/25.
//

import Foundation

struct ReissueAccessTokenUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository = AuthRepository()) {
        self.repository = repository
    }
    
    func execute(refreshToken: String) async throws -> String {
        return try await repository.usersTokens(with: RefreshTokenDTO(refreshToken: refreshToken)).accessToken
    }
}
