//
//  MatchingRequest.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct MatchingRequest: Equatable {
    let matchingStatus: MatchingStatus
    let lastMeetingTime: Date
}

extension MatchingRequest: Codable { }
