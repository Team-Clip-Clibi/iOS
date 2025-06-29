//
//  GetMeetingInProgressUseCase.swift
//  OneThing
//
//  Created by 오현식 on 6/6/25.
//

import Foundation

struct GetMeetingInProgressUseCase {
    private let repository: MatchingRepository
    
    init(repository: MatchingRepository = MatchingRepository()) {
        self.repository = repository
    }
    
    // TODO: 임시, 모임 시간만 임시로 반환
    func execute() async throws -> Date? {
        return try await self.repository.meetingInProgress().latestMatchingDateTime.ISO8601Date
    }
}
