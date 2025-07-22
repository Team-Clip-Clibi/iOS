//
//  RandomMatchingDuplicateCheckInfo.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct RandomMatchingDuplicateCheckInfo: Equatable {
    let meetingTime: Date
    let isDuplicated: Bool
}

extension RandomMatchingDuplicateCheckInfo: Codable { }
