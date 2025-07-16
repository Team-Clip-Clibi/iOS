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
    
    func execute() async throws -> (meetingDate: Date?, inMeetingInfo: InMeetingInfo) {
        let response = try await self.repository.meetingInProgress()
        let meetingDate = response.latestMatchingDateTime.ISO8601Date
        let inMeetingInfo = response.matchingProgressInfo
        
        return (meetingDate: meetingDate, inMeetingInfo: inMeetingInfo)
    }
}
