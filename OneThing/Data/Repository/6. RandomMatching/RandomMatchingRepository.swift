//
//  RandomMatchingRepository.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct RandomMatchingRepository {
    
    private let networkService = OTNetworkService()
    
    
    // MARK: - GET
    
    func randomDuplicateCheck() async throws -> RandomMatchingDuplicateCheckDTO {
        let endpoint = EndPoint(
            path: "/random/duplicate-check",
            method: .get,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.get(endpoint: endpoint)
    }
    
    
    // MARK: - PATCH
    
    func updateRandomOrdersCapacity(with matchingId: String) async throws -> HTTPURLResponse {
        let endpoint = EndPoint(
            path: "/random/orders/\(matchingId)/capacity",
            method: .patch,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.patch(endpoint: endpoint)
    }
    
    
    // MARK: - POST
    
    func submitRandomOrders(
        _ dto: RandomOrderRequestDTO
    ) async throws -> (RandomOrderResponseDTO, HTTPURLResponse) {
        let endpoint = EndPoint(
            path: "/random/orders",
            method: .post,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.post(endpoint: endpoint, body: dto)
    }
}
