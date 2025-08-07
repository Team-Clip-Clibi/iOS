//
//  GetMatchingNoticeUseCase.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct GetMatchingNoticeUseCase {
    private let repository: MatchingManagementRepository
    
    init(repository: MatchingManagementRepository = MatchingManagementRepository()) {
        self.repository = repository
    }
    
    func execute() async throws -> [MatchingNoticeInfo] {
        return try await self.repository.matchingsNotices().matchingNoticeInfos
    }
    
    func execute(with lastMeetingTime: Date) async throws -> [MatchingNoticeInfo] {
        return try await self.repository.matchingsNotices(with: lastMeetingTime).matchingNoticeInfos
    }
}
