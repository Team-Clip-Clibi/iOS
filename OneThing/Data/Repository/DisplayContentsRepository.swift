//
//  DisplayContentsRepository.swift
//  OneThing
//
//  Created by 윤동주 on 5/3/25.
//

import Foundation

struct DisplayContentsRepository {
    
    private let networkService = OTNetworkService()
    
    // MARK: - GET
    
    func notice() async throws -> NoticeInfoDTO {
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
    
    func banners(with bannerInfoType: BannerInfoType) async throws -> BannerInfoDTO {
        let endpoint = EndPoint(
            path: "/displays/banners/\(bannerInfoType.rawValue)",
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
