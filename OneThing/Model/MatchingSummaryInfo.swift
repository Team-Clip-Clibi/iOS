//
//  MatchingSummaryInfo.swift
//  OneThing
//
//  Created by 오현식 on 5/9/25.
//

import Foundation

struct MatchingSummaryInfo: Equatable {
    
    enum Category {
        case onething
        case random
        case instant
        
        var description: String {
            switch self {
            case .onething: return "원띵 모임"
            case .random: return "랜덤 모임"
            case .instant: return "번개 모임"
            }
        }
    }
    
    let category: Category
    let matchingId: Int
    let daysUntilMeeting: Int
    let meetingPlace: String
}
