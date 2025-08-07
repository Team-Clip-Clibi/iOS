//
//  MatchingProgressInfo.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct MatchingProgressInfo: Equatable {
    let nicknameList: [String]
    let tmiList: [String]
    let nicknameOnethingMap: [String: String]
}

extension MatchingProgressInfo: Codable { }
