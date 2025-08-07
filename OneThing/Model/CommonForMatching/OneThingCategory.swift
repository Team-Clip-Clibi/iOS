//
//  OneThingCategory.swift
//  OneThing
//
//  Created by 오현식 on 5/27/25.
//

import SwiftUI

enum OneThingCategory: String, CaseIterable, Identifiable {
    case health =           "HEALTH"
    case money =            "MONEY"
    case life =             "LIFE"
    case relationship =     "RELATIONSHIP"
    case selfImprovement =  "SELF_IMPROVEMENT"
    case work =             "WORK"
    case hobby =            "HOBBY"
    
    var id: String { self.rawValue }
    
    var toKorean: String {
        switch self {
        case .health:           return "건강"
        case .money:            return "돈"
        case .life:             return "인생"
        case .relationship:     return "관계"
        case .selfImprovement:  return "자기개발"
        case .work:             return "직장"
        case .hobby:            return "취미"
        }
    }
    
    var imageResource: ImageResource {
        switch self {
        case .health:           return .health
        case .money:            return .money
        case .life:             return .life
        case .relationship:     return .relationship
        case .selfImprovement:  return .selfImprovement
        case .work:             return .work
        case .hobby:            return .hobby
        }
    }
}

extension OneThingCategory: Codable { }
