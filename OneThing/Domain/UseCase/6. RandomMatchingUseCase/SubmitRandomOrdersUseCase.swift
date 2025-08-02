//
//  SubmitRandomOrdersUseCase.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct SubmitRandomOrdersUseCase {
    private let repository: RandomMatchingRepository
    
    init(repository: RandomMatchingRepository = RandomMatchingRepository()) {
        self.repository = repository
    }
    
    func execute(_ request: RandomOrderRequest) async throws -> (RandomOrderResponse, Int) {
        let dto = RandomOrderRequestDTO(randomOrderRequest: request)
        let response = try await self.repository.submitRandomOrders(dto)
        return (response.0.randomOrderResponse, response.1.statusCode)
    }
}
