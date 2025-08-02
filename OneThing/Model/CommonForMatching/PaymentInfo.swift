//
//  PaymentInfo.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct PaymentInfo: Equatable {
    let matchingPrice: Int
    let paymentPrice: Int
    let refundPrice: Int
    let requestedAt: Date
    let approvedAt: Date
}

extension PaymentInfo: Codable { }
