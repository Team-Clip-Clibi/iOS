//
//  MatchingDate.swift
//  OneThing
//
//  Created by 오현식 on 5/20/25.
//

enum MatchingDate: CaseIterable {
    case friday
    case saturday
    case sunday
    
    // iOS에서 금요일 == 6, 토요일 == 7, 일요일 == 1
    var weekday: Int {
        switch self {
        case .friday:   return 6
        case .saturday: return 7
        case .sunday:   return 1
        }
    }
    
    var toKorean: String {
        switch self {
        case .friday:   return "금"
        case .saturday: return "토"
        case .sunday:   return "일"
        }
    }
}
