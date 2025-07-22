//
//  District.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

enum District: String, CaseIterable, Identifiable {
    case hongdaeHapjeong = "HONGDAE_HAPJEONG"
    case gangnam         = "GANGNAM"
    
    var id: String { self.rawValue }
    
    var toKorean: String {
        switch self {
        case .hongdaeHapjeong:  return "홍대/합정"
        case .gangnam:          return "강남"
        }
    }
}

extension District {
    
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

extension District: Codable { }
