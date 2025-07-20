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
    
    func unReadNotificationWithPaging(id: String) async throws -> NotificationDTO {
        let endpoint = EndPoint(
            path: "/notifications/unread/\(id)",
            method: .get,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.get(endpoint: endpoint)
    }
    
    func readNotification() async throws -> NotificationDTO {
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
    
    func readNotificationWithPaging(id: String) async throws -> NotificationDTO {
        let endpoint = EndPoint(
            path: "/notifications/read/\(id)",
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
    
    func updateBannerStatus(with id: Int) async throws -> HTTPURLResponse {
        let endpoint = EndPoint(
            path: "/notifications/banner/status/\(id)",
            method: .patch,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.patch(endpoint: endpoint)
    }
}
