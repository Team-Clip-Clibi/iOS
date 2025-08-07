//
//  MatchingNoticeInfo.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct MatchingNoticeInfo: Equatable {
    let matchingId: String
    let meetingTime: Date
    let matchingStatus: MatchingStatus
    let matchingType: MatchingType
    let myOneThingContent: String
    let restaurantName: String
    let location: String
    let menuCategory: String
    let jobInfos: [JobInfo]
    let dietaryInfos: [DietaryInfo]
}
extension MatchingNoticeInfo: Codable { }

struct JobInfo: Equatable {
    let jobName: String
    let count: Int
}
extension JobInfo: Codable { }

struct DietaryInfo: Equatable {
    let dietaryOption: String
    let count: Int
}
extension DietaryInfo: Codable { }
