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
    
    func execute(with bannerId: String) async throws -> Bool {
        let statusCode = try await self.repository.updateBannerStatus(with: bannerId).statusCode
        return statusCode == 200
    }
}
