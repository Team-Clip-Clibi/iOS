//
//  SubmitOnethingsOrderUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 6/17/25.
//

import Foundation

struct SubmitOnethingsOrderUseCase {
    private let repository: OnethingMatchingRepository

    init(repository: OnethingMatchingRepository = OnethingMatchingRepository()) {
        self.repository = repository
    }
    
    func execute(_ request: OnethingOrderRequest) async throws -> OnethingOrderResponse {
        let dto = OnethingOrderRequestDTO(onethingOrderRequest: request)
        return try await self.repository.submitOnethingsOrder(dto).0.onethingOrderResponse
    }
}
