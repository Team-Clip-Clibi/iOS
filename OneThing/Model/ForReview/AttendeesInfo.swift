//
//  AttendeesInfo.swift
//  OneThing
//
//  Created by 오현식 on 6/10/25.
//

import Foundation

enum AttendeesInfo: String, CaseIterable, Identifiable {
    case all               = "ALL"
    case hasNoAttendees     = "HAS_NO_ATTENDEES"
    
    var id: String { self.rawValue }
    
    var toKorean: String {
        switch self {
        case .all:              return "모두 참석했어요"
        case .hasNoAttendees:   return "참석하지 않은 멤버가 있어요"
        }
    }
}
