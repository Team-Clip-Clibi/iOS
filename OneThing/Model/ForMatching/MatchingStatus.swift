//
//  MatchingStatus.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

enum MatchingStatus: String {
    case applied    = "APPLIED"
    case confirmed  = "CONFIRMED"
    case completed  = "COMPLETED"
    case canceled   = "CANCELED"
    case noShow     = "NO_SHOW"
}

extension MatchingStatus: Codable { }
