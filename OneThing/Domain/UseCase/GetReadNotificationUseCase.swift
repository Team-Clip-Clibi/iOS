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
    
    func execute(with id: String = "") async throws -> [NotificationInfo] {
        if id.isEmpty {
            return try await self.repository.readNotification().notificationInfos
        } else {
            return try await self.repository.readNotificationWithPaging(id: id).notificationInfos
        }
    }
}
