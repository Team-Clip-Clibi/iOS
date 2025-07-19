//
//  GetMeetingProgressUseCase.swift
//  OneThing
//
//  Created by 오현식 on 6/6/25.
//

import Foundation

struct GetMeetingProgressUseCase {
    private let repository: MatchingRepository
    
    init(repository: MatchingRepository = MatchingRepository()) {
        self.repository = repository
    }
    
    func execute() async throws -> [MatchingProgressInfo] {
        return try await self.repository.meetingProgress().matchingProgress
    }
}
