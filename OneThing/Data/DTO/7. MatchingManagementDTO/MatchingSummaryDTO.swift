//
//  MatchingSummaryDTO.swift
//  OneThing
//
//  Created by 오현식 on 5/9/25.
//

import Foundation

struct MatchingSummaryDTO {
    let oneThingMatchings: [MatchingSummaryInfo]
    let randomMatchings: [MatchingSummaryInfo]
}

extension MatchingSummaryDTO: Codable { }
