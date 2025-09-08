//
//  MatchingType.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

enum MatchingType: String {
    case onething   = "ONE_THING"
    case random     = "RANDOM"
    case instant    = "INSTANT"
}
extension MatchingType: Codable { }
