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
    
    func isUnReadNotificationEmpty() async throws -> Bool {
        return try await self.execute().count == 0
    }
    
    func execute(with id: String = "") async throws -> [NotificationInfo] {
        if id.isEmpty {
            return try await self.repository.unReadNotification().notificationInfos
        } else {
            return try await self.repository.unReadNotificationWithPaging(id: id).notificationInfos
        }
    }
}
