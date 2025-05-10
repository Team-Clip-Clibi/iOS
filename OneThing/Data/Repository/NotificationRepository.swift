//
//  NotificationRepository.swift
//  OneThing
//
//  Created by 윤동주 on 5/3/25.
//

import Foundation

struct NotificationRepository {
    
    private let networkService = OTNetworkService()
    
    // MARK: - GET
    
    func notice() async throws -> NoticeDTO {
        let endpoint = EndPoint(
            path: "/displays/notices",
            method: .get,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.get(endpoint: endpoint)
    }
    
    func unReadNotification() async throws -> NotificationDTO {
        let endpoint = EndPoint(
            path: "/notifications/unread",
            method: .get,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.get(endpoint: endpoint)
    }
    
    // MARK: - PATCH
    
}
