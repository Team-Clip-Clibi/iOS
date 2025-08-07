//
//  UpdateUserNotifyUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 7/27/25.
//

import Foundation

struct UpdateUserNotifyUseCase {
    private let repository: UserInfoRepository
    
    init(repository: UserInfoRepository = UserInfoRepository()) {
        self.repository = repository
    }
    
    func execute(isAllowNotify: Bool) async throws -> Bool {
        let statusCode = try await repository.usersNotify(with: NotifyAllowDTO(isAllowNotify: isAllowNotify)).statusCode
        return statusCode == 204
    }
}
