//
//  OnethingOrderResponseDTO.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct OnethingOrderResponseDTO {
    let onethingOrderResponse: OnethingOrderResponse
}

extension OnethingOrderResponseDTO: Codable {
    
    init(from decoder: any Decoder) throws {
        let singleContainer = try decoder.singleValueContainer()
        self.onethingOrderResponse = try singleContainer.decode(OnethingOrderResponse.self)
    }
}
