//
//  SubmitPaymentsConfirmUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 6/17/25.
//

import Foundation

struct SubmitPaymentsConfirmUseCase {
    private let repository: PaymentsRepository

    init(repository: PaymentsRepository = PaymentsRepository()) {
        self.repository = repository
    }

    func execute(_ request: PaymentRequest) async throws -> Bool {
        let dto = PaymentRequestDTO(paymentRequest: request)
        let statusCode = try await self.repository.submitPaymentsConfirm(dto).statusCode
        return statusCode == 200
    }
}
