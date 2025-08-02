//
//  MatchingOverviewInfo.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct MatchingOverviewInfo: Equatable {
    let nextMatchingDate: Date
    let appliedMatchingCount: Int
    let confirmedMatchingCount: Int
    let isAllNoticeRead: Bool
}

extension MatchingOverviewInfo: Codable { }
