//
//  ConfirmPaymentUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 6/17/25.
//

import Foundation

struct ConfirmPaymentUseCase {
    private let repository: TossPaymentsRepository

    init(repository: TossPaymentsRepository = TossPaymentsRepository()) {
        self.repository = repository
    }

    func execute(paymentKey: String,
                 orderId: String,
                 orderType: OrderType
    ) async throws -> Bool {
        try await repository.paymentsConfirm(with: PaymentDTO(paymentKey: paymentKey,
                                                              orderId: orderId,
                                                              orderType: orderType))
    }
}
