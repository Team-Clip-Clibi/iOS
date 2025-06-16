//
//  MeetingReviewInfo.swift
//  OneThing
//
//  Created by 오현식 on 6/10/25.
//

import SwiftUI

enum MeetingReviewInfo: String, CaseIterable, Identifiable {
    case disappointed   = "DISAPPOINTED"
    case unsatisfied    = "UNSATISFIED"
    case neutral        = "NEUTRAL"
    case good           = "GOOD"
    case excellent      = "EXCELLENT"
    
    var id: String { self.rawValue }
    
    var toKorean: String {
        switch self {
        case .disappointed: return "실망이에요"
        case .unsatisfied:  return "아쉬워요"
        case .neutral:      return "보통이에요"
        case .good:         return "좋아요"
        case .excellent:    return "최고예요"
        }
    }
    
    var unSelectedImageResource: ImageResource {
        switch self {
        case .disappointed: return .uncheckDisappointed
        case .unsatisfied:  return .uncheckUnsatisfied
        case .neutral:      return .uncheckNeutral
        case .good:         return .uncheckGood
        case .excellent:    return .uncheckExcellent
        }
    }
    
    var selectedImageResource: ImageResource {
        switch self {
        case .disappointed: return .checkDisappointed
        case .unsatisfied:  return .checkUnsatisfied
        case .neutral:      return .checkNeutral
        case .good:         return .checkGood
        case .excellent:    return .checkExcellent
        }
    }
}
