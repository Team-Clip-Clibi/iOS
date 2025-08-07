//
//  DietaryDTO.swift
//  OneThing
//
//  Created by 윤동주 on 5/3/25.
//

import Foundation

struct DietaryDTO: Codable {
    var dietaryOption: String?
}

enum DietaryType: String, CaseIterable, Identifiable {
    case vegan      = "VEGAN"
    case vegetarian = "VEGETARIAN"
    case glutenFree = "GLUTEN_FREE"
    case all        = "ALL"
    case etc        = "ETC"
    
    var id: String { self.rawValue }
    
    var toKorean: String {
        switch self {
        case .vegan:        return "비건이에요"
        case .vegetarian:   return "베지테리언이에요"
        case .glutenFree:   return "글루텐프리를 지켜요"
        case .all:          return "다 잘먹어요"
        case .etc:          return "기타"
        }
    }
}
