//
//  JobDTO.swift
//  OneThing
//
//  Created by 윤동주 on 5/3/25.
//

import Foundation

struct JobDTO: Codable {
    let jobList: [JobType]
}

enum JobType: String, Codable, CaseIterable, Identifiable {
    case student       = "STUDENT"
    case manufacturing = "MANUFACTURING"
    case medical       = "MEDICAL"
    case art           = "ART"
    case it            = "IT"
    case service       = "SERVICE"
    case sales         = "SALES"
    case business      = "BUSINESS"
    case politics      = "POLITICS"
    case etc           = "ETC"
    
    var id: String { rawValue }
    
    var toKorean: String {
        switch self {
        case .student:       return "학생"
        case .manufacturing: return "제조업"
        case .medical:       return "의료업"
        case .art:           return "예술계"
        case .it:            return "IT"
        case .service:       return "서비스업"
        case .sales:         return "판매업"
        case .business:      return "사업"
        case .politics:      return "정치"
        case .etc:           return "기타"
        }
    }
}
