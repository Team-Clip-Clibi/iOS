//
//  MatchingDate.swift
//  OneThing
//
//  Created by 오현식 on 5/20/25.
//

enum MatchingDate: String, CaseIterable {
    case friday = "금"
    case saturday = "토"
    case sunday = "일"
    
    // iOS에서 금요일 == 6, 토요일 == 7, 일요일 == 1
    var weekday: Int {
        switch self {
        case .friday: return 6
        case .saturday: return 7
        case .sunday: return 1
        }
    }
}
