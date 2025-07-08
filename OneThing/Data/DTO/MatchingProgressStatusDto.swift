//
//  MatchingProgressStatusDto.swift
//  OneThing
//
//  Created by 오현식 on 6/6/25.
//

import Foundation

struct MatchingProgressStatusDto: Decodable {
    let latestMatchingDateTime: String
    let matchingProgressInfo: InMeetingInfo
    let checkedMatchingStart: Bool
    
    enum CodingKeys: String, CodingKey {
        case matchingId = "matchingId"
        case matchingType = "matchingType"
        case latestMatchingDateTime = "latestMatchingDatetime"
        case matchingProgressInfo  = "matchingProgressInfo"
        case checkedMatchingStart  = "checkedMatchingStart"
    }
}

extension MatchingProgressStatusDto {
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.latestMatchingDateTime = try container.decode(String.self, forKey: .latestMatchingDateTime)
        self.checkedMatchingStart = try container.decode(Bool.self, forKey: .checkedMatchingStart)
        
        let matchingId = try String(container.decode(Int.self, forKey: .matchingId))
        let matchingType = try container.decode(MatchingType.self, forKey: .matchingType)
        let originalInfo = try container.decode(InMeetingInfo.self, forKey: .matchingProgressInfo)
        
        self.matchingProgressInfo = InMeetingInfo(
            matchingId: matchingId,
            matchingType: matchingType,
            nicknameList: originalInfo.nicknameList,
            quizList: originalInfo.quizList,
            oneThingMap: originalInfo.oneThingMap
        )
    }
}

enum MatchingType: String, Codable {
    case oneThing   = "ONE_THING"
    case random     = "RANDOM"
}
