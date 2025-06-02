//
//  OneThingCategoryInfo.swift
//  OneThing
//
//  Created by 오현식 on 5/27/25.
//

import UIKit

enum OneThingCategory: String, CaseIterable, Identifiable {
    case health = "HEALTH"
    case money = "MONEY"
    case life = "LIFE"
    case love = "LOVE"
    case stepup = "STEPUP"
    case work = "WORK"
    case hobby = "HOBBY"
    
    var id: String { self.rawValue }
    
    var toKorean: String {
        switch self {
        case .health: return "건강"
        case .money: return "돈"
        case .life: return "인생"
        case .love: return "연애"
        case .stepup: return "자기개발"
        case .work: return "직장"
        case .hobby: return "취미"
        }
    }
    
    var imageResource: ImageResource {
        switch self {
        case .health: return .health
        case .money: return .money
        case .life: return .life
        case .love: return .love
        case .stepup: return .stepup
        case .work: return .work
        case .hobby: return .hobby
        }
    }
}
