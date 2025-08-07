//
//  UpdateLanguageUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 5/6/25.
//

import Foundation

struct UpdateLanguageUseCase {
    private let repository: UserInfoRepository
    
    init(repository: UserInfoRepository = UserInfoRepository()) {
        self.repository = repository
    }
    
    func execute(language: Language) async throws -> Bool {
        let statusCode = try await repository.usersLanguage(with: LanguageDTO(language: language)).statusCode
        return statusCode == 204
    }
}
