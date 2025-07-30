//
//  UpdatePhoneNumberUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 7/27/25.
//

import Foundation

struct UpdatePhoneNumberUseCase {
    private let repository: UserInfoRepository
    
    init(repository: UserInfoRepository = UserInfoRepository()) {
        self.repository = repository
    }
    
    func execute(phoneNumber: String) async throws -> Bool {
        let statusCode = try await repository.usersPhone(with: UpdatePhoneNumberDTO(phoneNumber: phoneNumber)).statusCode
        return statusCode == 204
    }
}

