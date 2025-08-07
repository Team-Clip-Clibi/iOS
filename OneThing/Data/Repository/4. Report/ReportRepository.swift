//
//  ReportRepository.swift
//  OneThing
//
//  Created by 윤동주 on 5/3/25.
//

import Foundation

struct ReportRepository {
    
    // MARK: - Properties

    private let networkService = OTNetworkService()

    // MARK: - POST
    
    /// 신고 등록 API
    func report(with dto: ReportDTO) async throws -> HTTPURLResponse {
        let endpoint = EndPoint(
            path: "/report",
            method: .post,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await networkService.post(endpoint: endpoint, body: dto)
    }
}
