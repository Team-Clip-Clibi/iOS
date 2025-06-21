//
//  MatchingProgressStatusDto.swift
//  OneThing
//
//  Created by 오현식 on 6/6/25.
//

import Foundation

struct MatchingProgressStatusDto: Codable {
    let matchingId: String
    let matchingType: MatchingType
    let latestMatchingDateTime: String
    let matchingProgressInfo: InMeetingInfo
    let checkedMatchingStart: Bool
}

enum MatchingType: String, Codable {
    case oneThing   = "ONE_THING"
    case random     = "RANDOM"
}
