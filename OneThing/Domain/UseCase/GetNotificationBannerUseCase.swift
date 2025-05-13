//
//  GetNotificationBannerUseCase.swift
//  OneThing
//
//  Created by 오현식 on 5/13/25.
//

import Foundation

struct GetNotificationBannerUseCase {
    private let repository: NotificationRepository
    
    init(repository: NotificationRepository = NotificationRepository()) {
        self.repository = repository
    }
    
    func execute() async throws -> [NotificationBannerInfo] {
        return try await self.repository.banners().notificationBannerInfo
    }
}
