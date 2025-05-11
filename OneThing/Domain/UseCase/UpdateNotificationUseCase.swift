//
//  UpdateNotificationUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 5/9/25.
//

import Foundation

struct UpdateNotificationUseCase {
    
    private let repository: UserInfoRepository
    
    init(repository: UserInfoRepository = UserInfoRepository()) {
        self.repository = repository
    }

    func execute(isAllowNotify: Bool) async throws -> Bool {
        let statusCode = try await repository.usersNotify(with: UpdateNotifyAllowDTO(isAllowNotify: isAllowNotify)).statusCode

        return statusCode == 204
    }
}
