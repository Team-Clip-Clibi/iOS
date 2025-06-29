//
//  OneThingOrderRequest.swift
//  OneThing
//
//  Created by 윤동주 on 6/17/25.
//

import Foundation

struct OneThingOrderRequest: Codable {
    let topic: String
    let district: District
    let preferredDates: [PreferredDate]
    let tmiContent: String
    let oneThingBudgetRange: BudgetRange
    let oneThingCategory: OneThingCategory
}

enum District: String, Codable, CaseIterable {
    case hongdaeHapjeong = "HONGDAE_HAPJEONG"
    case gangnam         = "GANGNAM"
    
    var toKorean: String {
        switch self {
        case .hongdaeHapjeong:  return "홍대/합정"
        case .gangnam:          return "강남"
        }
    }
    
    init?(korean: String) {
        switch korean {
        case District.hongdaeHapjeong.toKorean:
            self = .hongdaeHapjeong
        case District.gangnam.toKorean:
            self = .gangnam
        default:
            return nil
        }
    }
}

struct PreferredDate: Codable, Equatable {
    let date: String
    let timeSlot: TimeSlot
    
    static func ==(lhs: PreferredDate, rhs: PreferredDate) -> Bool {
        return lhs.date == rhs.date
    }
}

enum TimeSlot: String, Codable, CaseIterable {
    case dinner = "DINNER"
    
    var toKorean: String {
        switch self {
        case .dinner: return "저녁"
        }
    }
}

enum BudgetRange: String, Codable, CaseIterable {
    case low    = "LOW"
    case medium = "MEDIUM"
    case high   = "HIGH"
    
    var toKorean: String {
        switch self {
        case .low:    return "10,000원~30,000원"
        case .medium: return "30,000원~50,000원"
        case .high:   return "50,000원~70,000원"
        }
    }
}
