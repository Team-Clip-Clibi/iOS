//
//  EditMeetingEndUseCase.swift
//  OneThing
//
//  Created by 오현식 on 7/7/25.
//

import Foundation

struct EditMeetingEndUseCase {
    
    private let repository: MatchingRepository
    
    init(repository: MatchingRepository = MatchingRepository()) {
        self.repository = repository
    }
    
    func execute(type matchingType: MatchingType, with matchingId: String) async throws -> Bool {
        let response = try await self.repository.meetingEnded(type: matchingType, with: matchingId)
        
        return response.statusCode == 204
    }
}
