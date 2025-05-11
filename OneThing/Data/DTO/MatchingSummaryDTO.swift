//
//  MatchingSummaryDTO.swift
//  OneThing
//
//  Created by 오현식 on 5/9/25.
//

import Foundation

struct MatchingSummaryDTO: Codable {
    let oneThingMatchings: [Matching]
    let randomMatchings: [Matching]
}

extension MatchingSummaryDTO {
    
    func toDomain() -> [MatchingSummaryInfo] {
        var matchingSummaryInfos = [MatchingSummaryInfo]()
        matchingSummaryInfos += self.oneThingMatchings.map {
            MatchingSummaryInfo(
                category: .onething,
                matchingId: $0.matchingId,
                daysUntilMeeting: $0.daysUntilMeeting,
                meetingPlace: $0.meetingPlace
            )
        }
        matchingSummaryInfos += self.randomMatchings.map {
            MatchingSummaryInfo(
                category: .random,
                matchingId: $0.matchingId,
                daysUntilMeeting: $0.daysUntilMeeting,
                meetingPlace: $0.meetingPlace
            )
        }
        
        return matchingSummaryInfos
    }
}

struct Matching: Codable {
    let matchingId: Int
    let daysUntilMeeting: Int
    let meetingPlace: String
}
