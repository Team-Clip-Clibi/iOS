//
//  MatchingReviewDTO.swift
//  OneThing
//
//  Created by 오현식 on 6/20/25.
//

import Foundation

struct MatchingReviewDTO: Codable {
    let mood: MeetingReviewMood
    let positivePoints: String
    let negativePoints: String
    let reviewContent: String
    let noShowMembers: String
    let isMemberAllAttended: Bool
    
    enum CodingKeys: String, CodingKey {
        case mood = "mood"
        case positivePoints = "positivePoints"
        case negativePoints = "negativePoints"
        case reviewContent = "reviewContent"
        case noShowMembers = "noShowMembers"
        case isMemberAllAttended = "is_member_all_attended"
    }
}
