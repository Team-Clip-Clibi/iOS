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
    
    /// 새로운 알림 조회 API - 최초 조회 시
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
    
    /// 새로운 알림 조회 API - 최초 조회가 아닐 시
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
    
    /// 읽은 알림 조회 API - 최초 조회 시
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
    
    /// 읽은 알림 조회 API - 최초 조회 아닐 시
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
    
    /// 홈 화면 알림 배너 조회 API
    func banner() async throws -> NotificationBannerDTO {
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
    
    /// 홈 화면 알림 배너 닫음 상태 업데이트 API
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
    
    /// 알림 읽음 상태 업데이트 API
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
