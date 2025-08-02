//
//  MatchingDTO.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct MatchingDTO {
    let matchingInfos: [MatchingInfo]
}

extension MatchingDTO: Codable {
    
    init(from decoder: any Decoder) throws {
        let singleContainer = try decoder.singleValueContainer()
        self.matchingInfos = try singleContainer.decode([MatchingInfo].self)
    }
}
