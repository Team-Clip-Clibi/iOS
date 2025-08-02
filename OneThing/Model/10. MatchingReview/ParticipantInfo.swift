//
//  NeedReviewInfo.swift
//  OneThing
//
//  Created by 윤동주 on 7/27/25.
//

import Foundation

struct ParticipantInfo: Equatable {
    let id: String
    let nickname: String
}

extension ParticipantInfo: Codable { }
