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
    
    // 원띵 매칭 화면 날짜 선택
    func findWeekendDates(after days: Int = 21) -> [(String, String)] {
        
        var result = [(String, String)]()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd"
        
        let calendar = Calendar.current
        
        for dayOffset in 0...days {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: self) {
                let weekday = calendar.component(.weekday, from: date)
                
                if let matchingDate = MatchingDate.allCases.first(where: { $0.weekday == weekday }) {
                    let dateString = date.toString("MM.dd")
                    result.append((dateString, matchingDate.rawValue))
                }
            }
        }
        
        return result
    }
    
    // 홈 화면 확정된 모임 D-day
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
    
    // 알림 화면 알림 생성된 날짜
    var readNotiFormatted: String {
        return self.toString("M월 dd일")
    }
    
    // 모임 시간이 오늘인지 여부
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
}

extension Locale {

    static let Korea = Locale(identifier: "ko_KR")
}

extension TimeZone {

    static let Korea = TimeZone(identifier: "Asia/Seoul")!
}
