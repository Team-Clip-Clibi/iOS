//
//  Notification.swift
//  OneThing
//
//  Created by 오현식 on 7/8/25.
//

import Foundation

extension Notification.Name {
    
    /// Show meeting review alert
    static let showMeetingReviewAlert = Notification.Name("showMeetingReviewAlert")
    /// Fetch matchings for today
    static let fetchMatchingsForToday = Notification.Name("fetchMatchingsForToday")
}
