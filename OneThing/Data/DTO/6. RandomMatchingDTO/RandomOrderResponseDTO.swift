//
//  RandomOrderResponseDTO.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct RandomOrderResponseDTO {
    let randomOrderResponse: RandomOrderResponse
}

extension RandomOrderResponseDTO: Codable {
    
    init(from decoder: any Decoder) throws {
        let singleContainer = try decoder.singleValueContainer()
        self.randomOrderResponse = try singleContainer.decode(RandomOrderResponse.self)
    }
}
