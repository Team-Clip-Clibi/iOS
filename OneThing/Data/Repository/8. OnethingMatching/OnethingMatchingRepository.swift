//
//  OnethingMatchingRepository.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct OnethingMatchingRepository {
    
    private let networkService = OTNetworkService()
    
    
    // MARK: - POST
    
    func submitOnethingsOrder(
        _ dto: OnethingOrderRequestDTO
    ) async throws -> (OnethingOrderResponseDTO, HTTPURLResponse) {
        let endpoint = EndPoint(
            path: "/onethings/order",
            method: .post,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.post(endpoint: endpoint, body: dto)
    }
}
