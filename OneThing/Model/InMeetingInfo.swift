//
//  InMeetingInfo.swift
//  OneThing
//
//  Created by 오현식 on 6/20/25.
//

import Foundation

struct InMeetingInfo: Equatable {
    let matchingId: String
    let matchingType: MatchingType
    let nicknameList: [String]
    let quizList: [String]
    let oneThingMap: [String: String]
}
extension InMeetingInfo: Codable { }
