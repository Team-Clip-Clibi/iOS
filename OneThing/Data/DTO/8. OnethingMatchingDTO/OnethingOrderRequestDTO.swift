//
//  OnethingOrderRequestDTO.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct OnethingOrderRequestDTO {
    let onethingOrderRequest: OnethingOrderRequest
}

extension OnethingOrderRequestDTO: Codable {
    
    func encode(to encoder: any Encoder) throws {
        var singleContainer = encoder.singleValueContainer()
        try singleContainer.encode(self.onethingOrderRequest)
    }
}
