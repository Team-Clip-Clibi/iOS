//
//  InMeetingInfo.swift
//  OneThing
//
//  Created by 오현식 on 6/20/25.
//

import Foundation

struct InMeetingInfo: Equatable {
    let nicknameList: [String]
    let quizList: [String]
    let oneThingMap: [String: String]
}

extension InMeetingInfo: Codable { }
