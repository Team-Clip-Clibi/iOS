//
//  UpdateNotificationBannerUseCase.swift
//  OneThing
//
//  Created by 오현식 on 5/13/25.
//

import Foundation

struct UpdateNotificationBannerUseCase {
    private let repository: NotificationRepository
    
    init(repository: NotificationRepository = NotificationRepository()) {
        self.repository = repository
    }
    
    func execute(with id: Int) async throws -> HTTPURLResponse {
        return try await self.repository.updateBannerStatus(with: id)
    }
}
