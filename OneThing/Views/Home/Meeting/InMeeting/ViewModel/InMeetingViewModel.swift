//
//  InMeetingViewModel.swift
//  OneThing
//
//  Created by 오현식 on 6/20/25.
//

import Foundation

@Observable
class InMeetingViewModel {
    
    struct State {
        fileprivate(set) var nicknames: [String]
        fileprivate(set) var tmis: [String]
        fileprivate(set) var onethings: [OnethingInfo]
        fileprivate(set) var isMeetingEnded: Bool
        
        var onethingCount: Int { return self.onethings.count }
    }
    var currentState: State
    
    let getMatchingsUseCase: GetMatchingsUseCase
    let updateMatchingsStatusUseCase: UpdateMatchingsStatusUseCase
    
    let matchingId: String
    let matchingType: MatchingType
    
    init(
        getMatchingsUseCase: GetMatchingsUseCase = GetMatchingsUseCase(),
        updateMatchingsStatusUseCase: UpdateMatchingsStatusUseCase = UpdateMatchingsStatusUseCase(),
        matchingId: String,
        matchingType: MatchingType
    ) {
        self.getMatchingsUseCase = getMatchingsUseCase
        self.updateMatchingsStatusUseCase = updateMatchingsStatusUseCase
        
        self.matchingId = matchingId
        self.matchingType = matchingType
        
        self.currentState = State(nicknames: [], tmis: [], onethings: [], isMeetingEnded: false)
    }
    
    func matchingProgress() async {
        
        do {
            let matchingProgressInfo = try await self.getMatchingsUseCase.matchingsProgress(
                type: self.matchingType,
                with: self.matchingId
            )
            
            await MainActor.run {
                self.currentState.nicknames = matchingProgressInfo.nicknameList
                self.currentState.tmis = matchingProgressInfo.tmiList
                self.currentState.onethings = matchingProgressInfo.nicknameOnethingMap
                    .enumerated()
                    .map { index, element in
                        OnethingInfo(number: index+1, category: element.key, message: element.value)
                    }
            }
        } catch {
            
            await MainActor.run {
                self.currentState.nicknames = []
                self.currentState.tmis = []
                self.currentState.onethings = []
            }
        }
    }
    
    func meetingEnded() async {
        
        do {
            let isMeetingEnded = try await self.updateMatchingsStatusUseCase.matchingsEnded(
                type: self.matchingType,
                with: self.matchingId
            )
            
            await MainActor.run {
                self.currentState.isMeetingEnded = isMeetingEnded
            }
        } catch {
            
            await MainActor.run {
                self.currentState.isMeetingEnded = false
            }
        }
    }
}
