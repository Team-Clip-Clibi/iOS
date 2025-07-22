//
//  GetReadNotificationUseCase.swift
//  OneThing
//
//  Created by 오현식 on 5/11/25.
//

import Foundation

struct GetReadNotificationUseCase {
    private let repository: NotificationRepository
    
    init(repository: NotificationRepository = NotificationRepository()) {
        self.repository = repository
    }
    
    func execute() async throws -> [NotificationInfo] {
        return try await self.repository.readNotifications().notificationInfos
    }
    
    func execute(with notificationId: String) async throws -> [NotificationInfo] {
        return try await self.repository.readNotifications(with: notificationId).notificationInfos
    }
}
