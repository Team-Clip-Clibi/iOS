//
//  PreferredDate.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct PreferredDate {
    let date: String
    let timeSlot: TimeSlot
}

extension PreferredDate: Codable { }
extension PreferredDate: Equatable {
    
    static func ==(lhs: PreferredDate, rhs: PreferredDate) -> Bool {
        return lhs.date == rhs.date
    }
}
