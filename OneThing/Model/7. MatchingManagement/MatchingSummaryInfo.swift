//
//  MatchingSummaryInfo.swift
//  OneThing
//
//  Created by 오현식 on 5/9/25.
//

import Foundation

struct MatchingSummaryInfo: Equatable {
    let matchingId: Int
    let daysUntilMeeting: Int
    let meetingTime: Date
    let meetingPlace: String
}

extension MatchingSummaryInfo: Codable { }
