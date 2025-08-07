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
    
    /// 공지/새소식 조회 API
    func displaysNotices() async throws -> NoticeInfoDTO {
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
    
    /// 배너 조회 API
    func displaysBanners(with bannerInfoType: BannerInfoType) async throws -> [BannerInfoDTO] {
        var endpoint = EndPoint(
            path: "/displays/banners/\(bannerInfoType.rawValue)",
            method: .get,
            headers: [
                "Content-Type": "application/json",
            ]
        )
        
        if bannerInfoType == .home {
            endpoint.headers["Authorization"] = "Bearer \(TokenManager.shared.accessToken)"
        }
        
        return try await self.networkService.get(endpoint: endpoint)
    }
    
    // MARK: - PATCH
    
}
