//
//  MatchingProgressInfo.swift
//  OneThing
//
//  Created by 오현식 on 7/18/25.
//

import Foundation

struct MatchingProgressInfo: Equatable {
    let id: String
    let matchingId: String
    let meetingTime: Date
    let matchingStatus: MatchingStatus
    let matchingType: MatchingType
    let myOneThingContent: String
    let isReviewWritten: Bool
}
extension MatchingProgressInfo: Codable {
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.matchingId = try container.decode(String.self, forKey: .matchingId)
        self.meetingTime = (try container.decode(String.self, forKey: .meetingTime)).ISO8601Date ?? Date()
        self.matchingStatus = try container.decode(MatchingStatus.self, forKey: .matchingStatus)
        self.matchingType = try container.decode(MatchingType.self, forKey: .matchingType)
        self.myOneThingContent = try container.decode(String.self, forKey: .myOneThingContent)
        self.isReviewWritten = try container.decode(Bool.self, forKey: .isReviewWritten)
    }
}

enum MatchingStatus: String {
    case applied    = "APPLIED"
    case confirmed  = "CONFIRMED"
    case completed  = "COMPLETED"
    case canceled   = "CANCELED"
    case noShow     = "NO_SHOW"
}
extension MatchingStatus: Codable { }

enum MatchingType: String {
    case onething   = "ONE_THING"
    case random     = "RANDOM"
}
extension MatchingType: Codable { }
