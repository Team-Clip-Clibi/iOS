//
//  RelationshipDTO.swift
//  OneThing
//
//  Created by 윤동주 on 5/3/25.
//

import Foundation

struct RelationshipDTO: Codable {
    var relationshipStatus: RelationshipStatus?
    var isSameRelationshipConsidered: Bool?
}

enum RelationshipStatus: String, CaseIterable, Identifiable, Codable {
    case single   = "SINGLE"
    case couple   = "COUPLE"
    case marriage = "MARRIAGE"
    case secret   = "SECRET"
    
    var id: String { rawValue }
    var toKorean: String {
        switch self {
        case .single:   return "싱글"
        case .couple:   return "연애중"
        case .marriage: return "기혼"
        case .secret:   return "밝히고 싶지 않아요"
        }
    }
}
