//
//  OnethingInfo.swift
//  OneThing
//
//  Created by 오현식 on 6/4/25.
//

import SwiftUI

struct OnethingInfo {
    let number: Int
    let category: String
    let message: String
    
    var backgroundColor: Color {
        switch self.number {
        case 1: return .orange100
        case 2: return .green100
        case 3: return .blue100
        case 4: return .yellow100
        case 5: return .purple200
        case 6: return .coral100
        case 7: return .mint100
        case 8: return .pink100
        default: return .white100
        }
    }
}
