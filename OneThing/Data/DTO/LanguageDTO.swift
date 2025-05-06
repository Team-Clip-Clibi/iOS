//
//  LanguageDTO.swift
//  OneThing
//
//  Created by 윤동주 on 5/3/25.
//

import Foundation

struct LanguageDTO: Codable {
    var language: Language
}

enum Language: String, Codable, CaseIterable, Identifiable {
    case korean = "KOREAN"
    case english = "ENGLISH"
    case both = "BOTH"
    
    var id: String { rawValue }
    
    var toKorean: String {
        switch self {
        case .korean: return "한국어"
        case .english: return "영어"
        case .both: return "한국어, 영어 모두 가능"
        }
    }
}
