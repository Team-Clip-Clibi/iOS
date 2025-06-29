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
    let checkedMatchingStart: Bool
}

extension MatchingProgressStatusDto {
    
    enum MatchingType: String, Codable {
        case oneThing   = "ONE_THING"
        case random     = "RANDOM"
    }
}

struct matchingProgressInfo: Codable {
    let nicknameList: [String]
    let quizList: [String]
    let oneThingMap: OneThingMap
}

struct OneThingMap: Codable {
    let additionalProp1: String
    let additionalProp2: String
    let additionalProp3: String
}
