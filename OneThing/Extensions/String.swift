//
//  String.swift
//  OneThing
//
//  Created by 오현식 on 6/6/25.
//

import Foundation

extension String {
    
    func toDate(_ format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: Locale.preferredLanguages[0])
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }

    var ISO8601Date: Date? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = .current
        return dateFormatter.date(from: self) ??
        self.toDate(String.ISO8601FormatString1) ??
        self.toDate(String.ISO8601FormatString2) ??
        self.toDate(String.ISO8601FormatString3) ??
        self.toDate(String.ISO8601FormatString4)
    }

    static let ISO8601FormatString1: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    static let ISO8601FormatString2: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
    static let ISO8601FormatString3: String = "yyyy-MM-dd'T'HH:mm:ss"
    static let ISO8601FormatString4: String = "HH:mm:ss"
}
