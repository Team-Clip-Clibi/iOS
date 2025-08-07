//
//  NeedReviewInfo.swift
//  OneThing
//
//  Created by 윤동주 on 7/27/25.
//

import Foundation

struct NeedReviewInfo: Equatable {
    let matchingId: String
    let meetingTime: Date
    let matchingType: MatchingType
}

extension NeedReviewInfo: Codable { }
