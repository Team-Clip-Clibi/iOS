//
//  TossPaymentsRepository.swift
//  OneThing
//
//  Created by 윤동주 on 6/17/25.
//

import Foundation

struct PaymentsRepository {
    private let networkService = OTNetworkService()
    
    // MARK: - POST
    
    func submitPaymentsConfirm(_ dto: PaymentRequestDTO) async throws -> HTTPURLResponse {
        let endpoint = EndPoint(
            path: "/payments/confirm",
            method: .post,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await self.networkService.post(endpoint: endpoint, body: dto)
    }
}
