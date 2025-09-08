//
//  InMeetingContent.swift
//  OneThing
//
//  Created by 오현식 on 6/5/25.
//

import SwiftUI

struct InMeetingContentInfo {
    let number: Int
    let message: String
}

extension InMeetingContentInfo {
    
    static let mock: [InMeetingContentInfo] = [
        InMeetingContentInfo(number: 1, message: "대화 주제 추천 대화 주제 추천"),
        InMeetingContentInfo(number: 2, message: "대화 주제 추천 대화 주제 추천"),
        InMeetingContentInfo(number: 3, message: "대화 주제 추천 대화 주제 추천"),
        InMeetingContentInfo(number: 4, message: "대화 주제 추천 대화 주제 추천"),
        InMeetingContentInfo(number: 5, message: "대화 주제 추천 대화 주제 추천"),
        InMeetingContentInfo(number: 6, message: "대화 주제 추천 대화 주제 추천"),
        InMeetingContentInfo(number: 7, message: "대화 주제 추천 대화 주제 추천"),
        InMeetingContentInfo(number: 8, message: "대화 주제 추천 대화 주제 추천")
    ]
}
