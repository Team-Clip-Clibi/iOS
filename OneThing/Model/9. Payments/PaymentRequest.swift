//
//  PaymentInfo.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct PaymentRequest: Equatable {
    enum OrderType: String, CaseIterable {
        case onething = "ONETHING"
        case random = "RANDOM"

        var toKorean: String {
            switch self {
            case .onething: return "원띵"
            case .random:   return "랜덤"
            }
        }
    }
    
    let paymentKey: String
    let orderId: String
    let orderType: OrderType
}

extension PaymentRequest: Codable { }
extension PaymentRequest.OrderType: Codable { }
