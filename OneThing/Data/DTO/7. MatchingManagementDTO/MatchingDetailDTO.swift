//
//  MatchingDetailDTO.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct MatchingDetailDTO {
    let matchingDetailInfo: MatchingDetailInfo
}

extension MatchingDetailDTO: Codable {
    
    init(from decoder: any Decoder) throws {
        let singleContainer = try decoder.singleValueContainer()
        self.matchingDetailInfo = try singleContainer.decode(MatchingDetailInfo.self)
    }
}
