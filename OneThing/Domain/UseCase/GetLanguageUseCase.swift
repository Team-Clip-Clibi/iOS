//
//  GetLanguageUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 5/6/25.
//

import Foundation

struct GetLanguageUseCase {
    private let repository: UserInfoRepository
    
    init(repository: UserInfoRepository = UserInfoRepository()) {
        self.repository = repository
    }
    
    func execute() async throws -> Language {
        let result = try await repository.usersLanguage()
        
        return result.language
    }
}
