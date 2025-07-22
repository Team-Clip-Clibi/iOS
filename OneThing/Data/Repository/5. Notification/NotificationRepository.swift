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
    
    func unReadNotifications() async throws -> NotificationDTO {
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
    
    func unReadNotifications(with notificationId: String) async throws -> NotificationDTO {
        let endpoint = EndPoint(
            path: "/notifications/unread/\(notificationId)",
            method: .get,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.get(endpoint: endpoint)
    }
    
    func readNotifications() async throws -> NotificationDTO {
        let endpoint = EndPoint(
            path: "/notifications/read",
            method: .get,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.get(endpoint: endpoint)
    }
    
    func readNotifications(with notificationId: String) async throws -> NotificationDTO {
        let endpoint = EndPoint(
            path: "/notifications/read/\(notificationId)",
            method: .get,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.get(endpoint: endpoint)
    }
    
    func banners() async throws -> NotificationBannerDto {
        let endpoint = EndPoint(
            path: "/notifications/banner",
            method: .get,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.get(endpoint: endpoint)
    }
    
    
    // MARK: - PATCH
    
    func updateNotificationStatus(with notificationId: String) async throws -> HTTPURLResponse {
        let endpoint = EndPoint(
            path: "/notifications/status/\(notificationId)",
            method: .patch,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.patch(endpoint: endpoint)
    }
    
    func updateBannerStatus(with bannerId: String) async throws -> HTTPURLResponse {
        let endpoint = EndPoint(
            path: "/notifications/banner/status/\(bannerId)",
            method: .patch,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.patch(endpoint: endpoint)
    }
}
