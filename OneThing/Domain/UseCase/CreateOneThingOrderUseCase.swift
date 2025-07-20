//
//  CreateOneThingOrderUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 6/17/25.
//

import Foundation

struct CreateOneThingOrderUseCase {
    private let repository: PaymentsRepository

    init(repository: PaymentsRepository = PaymentsRepository()) {
        self.repository = repository
    }
    
    func execute(
        topic: String,
        district: District,
        preferredDates: [PreferredDate],
        tmiContent: String,
        oneThingBudgetRange: BudgetRange,
        oneThingCategory: OneThingCategory
    ) async throws -> OneThingOrderResponse {
        let request = OneThingOrderRequest(
            topic: topic,
            district: district,
            preferredDates: preferredDates,
            tmiContent: tmiContent,
            oneThingBudgetRange: oneThingBudgetRange,
            oneThingCategory: oneThingCategory
        )
        return try await repository.onethingsOrder(with: request)
    }
}
