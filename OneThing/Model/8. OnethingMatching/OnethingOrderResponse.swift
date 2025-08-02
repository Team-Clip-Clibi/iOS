//
//  OneThingOrderResponse.swift
//  OneThing
//
//  Created by 윤동주 on 6/17/25.
//

import Foundation

struct OnethingOrderResponse: Equatable {
    let orderId: String
    let amount: Int
}

extension OnethingOrderResponse: Codable { }
