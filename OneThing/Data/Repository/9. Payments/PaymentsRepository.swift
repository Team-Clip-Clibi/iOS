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
    
    func onethingsOrder(with dto: OneThingOrderRequest) async throws -> OneThingOrderResponse {
        let endpoint = EndPoint(
            path: "/onethings/order",
            method: .post,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await networkService.post(endpoint: endpoint, body: dto).0
    }
    
    func paymentsConfirm(with dto: PaymentDTO) async throws -> Bool {
        let endpoint = EndPoint(
            path: "/users/nickname/available",
            method: .post,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        do {
            return try await networkService.post(endpoint: endpoint, body: dto).statusCode == 200
        } catch let error as NetworkError {
            if case .invalidHttpStatusCode(let code) = error, code == 400 {
                return false
            } else {
                throw error
            }
        }
    }
}
