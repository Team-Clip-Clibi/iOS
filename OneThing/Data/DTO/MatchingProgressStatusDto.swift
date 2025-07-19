//
//  MatchingProgressStatusDto.swift
//  OneThing
//
//  Created by 오현식 on 6/6/25.
//

import Foundation

struct MatchingProgressStatusDto: Decodable {
    let matchingProgress: [MatchingProgressInfo]
}

extension MatchingProgressStatusDto {
    
    init(from decoder: any Decoder) throws {
        let singleContainer = try decoder.singleValueContainer()
        self.matchingProgress = try singleContainer.decode([MatchingProgressInfo].self)
    }
}
