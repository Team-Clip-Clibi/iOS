//
//  OneThingOrderResponse.swift
//  OneThing
//
//  Created by 윤동주 on 6/17/25.
//

import Foundation

struct OneThingOrderResponse: Codable {
    let orderId: String
    let amount: Int
    
    private enum CodingKeys: String, CodingKey {
        case orderId
        case amount
    }
}
