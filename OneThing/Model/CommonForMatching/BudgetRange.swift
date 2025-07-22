//
//  BudgetRange.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

enum BudgetRange: String, CaseIterable, Identifiable {
    case low    = "LOW"
    case medium = "MEDIUM"
    case high   = "HIGH"
    
    var id: String { self.rawValue }
    
    var toKorean: String {
        switch self {
        case .low:    return "10,000원~30,000원"
        case .medium: return "30,000원~50,000원"
        case .high:   return "50,000원~70,000원"
        }
    }
}

extension BudgetRange: Codable { }
