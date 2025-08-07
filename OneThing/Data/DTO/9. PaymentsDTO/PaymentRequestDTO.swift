//
//  PaymentRequestDTO.swift
//  OneThing
//
//  Created by 윤동주 on 6/17/25.
//

import Foundation

struct PaymentRequestDTO {
    let paymentRequest: PaymentRequest
}

extension PaymentRequestDTO: Codable {
    
    func encode(to encoder: any Encoder) throws {
        var singleContainer = encoder.singleValueContainer()
        try singleContainer.encode(self.paymentRequest)
    }
}
