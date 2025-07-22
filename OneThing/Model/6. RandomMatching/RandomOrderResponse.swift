//
//  RandomOrderInfo.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct RandomOrderResponse: Equatable {
    let orderId: String
    let matchingId: String
    let amount: Int
    let meetingTime: Date
    let meetingPlace: String
    let meetingLocation: String
}

extension RandomOrderResponse: Codable {
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.orderId = "\(try container.decode(Int.self, forKey: .orderId))"
        self.matchingId = "\(try container.decode(Int.self, forKey: .matchingId))"
        self.amount = try container.decode(Int.self, forKey: .amount)
        self.meetingTime = try container.decode(Date.self, forKey: .meetingTime)
        self.meetingPlace = try container.decode(String.self, forKey: .meetingPlace)
        self.meetingLocation = try container.decode(String.self, forKey: .meetingLocation)
    }
}
