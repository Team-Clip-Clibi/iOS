//
//  SimpleDefaults.swift
//  OneThing
//
//  Created by 오현식 on 8/14/25.
//

import Foundation

final class SimpleDefaults {
    
    enum DataType: String {
        case inMeeting
        case review
    }
    
    static let shared = SimpleDefaults()
    
    
    // MARK: Has inMeetings or reviews

    private let recentMatchingsKey: String = "com.clip.onething.matchings.recent"

    @discardableResult
    func initRecentMatchings(with type: DataType) -> [MatchingInfo] {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        let key: String = "\(self.recentMatchingsKey).\(type)"
        UserDefaults.standard.set([], forKey: key)
        return []
    }

    func loadRecentMatchings(with type: DataType) -> [MatchingInfo] {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        let key: String = "\(self.recentMatchingsKey).\(type)"
        guard let array = UserDefaults.standard.array(forKey: key) as? [MatchingInfo] else {
            return self.initRecentMatchings(with: type)
        }
        return array
    }

    @discardableResult
    func saveRecentMatchings(_ matchings: [MatchingInfo], with type: DataType) -> [MatchingInfo] {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        // 저장할 MatchingInfo 배열 초기화
        var new = self.loadRecentMatchings(with: type)
        // 이미 저장된 중복 값 제거
        new.removeAll(where: { matchings.contains($0) })
        // 새로 저장할 Matching 배열 추가
        new.append(contentsOf: matchings)
        let key: String = "\(self.recentMatchingsKey).\(type)"
        UserDefaults.standard.set(new, forKey: key)
        return matchings
    }
    
    @discardableResult
    func removeRecentMatchings(_ matchingIds: [String], with type: DataType) -> [MatchingInfo] {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        var new = self.loadRecentMatchings(with: type)
        new.removeAll(where: { matching in matchingIds.contains(where: { $0 == matching.id }) })
        let key: String = "\(self.recentMatchingsKey).\(type)"
        UserDefaults.standard.set(new, forKey: key)
        return new
    }
    
    func isRecentMatchingsEmpty(with type: DataType) -> Bool {
        return self.loadRecentMatchings(with: type).isEmpty
    }
}
