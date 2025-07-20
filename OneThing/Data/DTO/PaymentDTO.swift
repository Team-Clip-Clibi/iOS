//
//  PaymentDTO.swift
//  OneThing
//
//  Created by 윤동주 on 6/17/25.
//

import Foundation

struct PaymentDTO: Codable {
    let paymentKey: String
    let orderId: String
    let orderType: OrderType

    private enum CodingKeys: String, CodingKey {
        case paymentKey, orderId, orderType
    }
}

enum OrderType: String, Codable, CaseIterable {
    case random = "RANDOM"
    case oneThing = "ONETHING"

    var toKorean: String {
        switch self {
        case .random:   return "랜덤"
        case .oneThing: return "원띵"
        }
    }
}
