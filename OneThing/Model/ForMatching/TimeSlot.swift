//
//  TimeSlot.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

enum TimeSlot: String, CaseIterable {
    case dinner = "DINNER"
    
    var toKorean: String {
        switch self {
        case .dinner: return "저녁"
        }
    }
}

extension TimeSlot: Codable { }
