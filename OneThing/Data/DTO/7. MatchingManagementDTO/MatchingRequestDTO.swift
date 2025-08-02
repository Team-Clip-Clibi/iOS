//
//  MatchingRequestDTO.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct MatchingRequestDTO {
    let matchingRequest: MatchingRequest
}

extension MatchingRequestDTO: Codable {
    
    func encode(to encoder: any Encoder) throws {
        var singleContainer = encoder.singleValueContainer()
        try singleContainer.encode(self.matchingRequest)
    }
}
