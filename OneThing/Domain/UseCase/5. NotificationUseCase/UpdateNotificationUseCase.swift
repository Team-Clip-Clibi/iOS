//
//  UpdateNotificationUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 5/9/25.
//

import Foundation

struct UpdateNotificationUseCase {
    
    private let repository: NotificationRepository
    
    init(repository: NotificationRepository = NotificationRepository()) {
        self.repository = repository
    }

    func execute(with notificationId: String) async throws -> Bool {
        let statusCode = try await repository.updateNotificationStatus(with: notificationId).statusCode
        return statusCode == 200
    }
}
