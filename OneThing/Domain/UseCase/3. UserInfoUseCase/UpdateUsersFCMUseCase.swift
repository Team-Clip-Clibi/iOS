//
//  UpdateUsersFCMUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 7/27/25.
//

import Foundation

struct UpdateUsersFCMUseCase {
    private let repository: UserInfoRepository
    
    init(repository: UserInfoRepository = UserInfoRepository()) {
        self.repository = repository
    }
    
    func execute(fcmToken: String) async throws -> Bool {
        let statusCode = try await repository.usersFCM(with: FCMTokenDTO(fcmToken: fcmToken)).statusCode
        return statusCode == 204
    }
}
