//
//  MatchingNoticeDTO.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct MatchingNoticeDTO {
    let matchingNoticeInfos: [MatchingNoticeInfo]
}

extension MatchingNoticeDTO: Codable {
    
    init(from decoder: any Decoder) throws {
        let singleContainer = try decoder.singleValueContainer()
        self.matchingNoticeInfos = try singleContainer.decode([MatchingNoticeInfo].self)
    }
}
