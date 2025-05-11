//
//  Date.swift
//  OneThing
//
//  Created by 오현식 on 5/10/25.
//

import Foundation

extension Date {
    
    func toString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = .Korea
        formatter.timeZone = .Korea
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func infoReadableTimeTakenFromThis(to: Date) -> String {

        let from: TimeInterval = self.timeIntervalSince1970
        let to: TimeInterval = to.timeIntervalSince1970
        let gap: TimeInterval = max(0, to - from)

        let time: Int = .init(gap)
        let days: Int = time / (24 * 60 * 60)
        let hours: Int = .init(time % (24 * 60 * 60)) / (60 * 60)
        let minutes: Int = .init(time % (60 * 60)) / 60
        
        if days > 0 && days < 365 {
            return "\(days)일 전".trimmingCharacters(in: .whitespaces)
        }
        
        if hours > 0 && hours < 24 {
            return "\(hours)시간 전".trimmingCharacters(in: .whitespaces)
        }
        
        if minutes > 0 && minutes < 60 {
            return "\(minutes)분 전".trimmingCharacters(in: .whitespaces)
        }

        return "0분 전"
    }
    
    var readNotiFormatted: String {
        return self.toString("M월 dd일")
    }
}

extension Locale {

    static let Korea = Locale(identifier: "ko_KR")
}

extension TimeZone {

    static let Korea = TimeZone(identifier: "Asia/Seoul")!
}
