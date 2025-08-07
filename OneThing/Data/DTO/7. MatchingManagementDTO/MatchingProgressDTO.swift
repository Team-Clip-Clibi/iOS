//
//  MatchingProgressInfoDTO.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct MatchingProgressDTO {
    let matchingProgressInfo: MatchingProgressInfo
}

extension MatchingProgressDTO: Codable {
    
    init(from decoder: any Decoder) throws {
        let singleContainer = try decoder.singleValueContainer()
        self.matchingProgressInfo = try singleContainer.decode(MatchingProgressInfo.self)
    }
}
