//
//  GetUnReadNotificationUseCase.swift
//  OneThing
//
//  Created by 오현식 on 5/9/25.
//

import Foundation

struct GetUnReadNotificationUseCase {
    private let repository: NotificationRepository
    
    init(repository: NotificationRepository = NotificationRepository()) {
        self.repository = repository
    }
    
    func execute() async throws -> [NotificationInfo] {
        return try await self.repository.unReadNotifications().notificationInfos
    }
    
    func execute(with notificationId: String) async throws -> [NotificationInfo] {
        return try await self.repository.unReadNotifications(with: notificationId).notificationInfos
    }
}
