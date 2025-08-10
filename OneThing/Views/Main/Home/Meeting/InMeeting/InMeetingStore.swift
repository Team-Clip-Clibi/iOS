//
//  InMeetingStore.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import Foundation

@Observable
class InMeetingStore: OTStore {
    
    enum Action: OTAction {
        case landing
        case ended
    }
    
    enum Process: OTProcess {
        case matchingProgress([String], [String], [OnethingInfo])
        case updateIsMeetingEnded(Bool)
    }
    
    struct State: OTState {
        fileprivate(set) var nicknames: [String]
        fileprivate(set) var tmis: [String]
        fileprivate(set) var onethings: [OnethingInfo]
        fileprivate(set) var isMeetingEnded: Bool
        
        var onethingCount: Int { return self.onethings.count }
    }
    var state: State
    
    let getMatchingsUseCase: GetMatchingsUseCase
    let updateMatchingsStatusUseCase: UpdateMatchingsStatusUseCase
    
    let matchingId: String
    let matchingType: MatchingType
    
    init(
        getMatchingsUseCase: GetMatchingsUseCase,
        updateMatchingsStatusUseCase: UpdateMatchingsStatusUseCase,
        matchingId: String,
        matchingType: MatchingType
    ) {
        
        self.state = State(nicknames: [], tmis: [], onethings: [], isMeetingEnded: false)
        
        self.getMatchingsUseCase = getMatchingsUseCase
        self.updateMatchingsStatusUseCase = updateMatchingsStatusUseCase
        
        self.matchingId = matchingId
        self.matchingType = matchingType
    }
    
    func process(_ action: Action) async -> OTProcessResult<Process> {
        switch action {
        case .landing:
            return await self.matchingProgress()
        case .ended:
            return await self.meetingEnded()
        }
    }
    
    func reduce(state: State, process: Process) -> State {
        var newState = state
        switch process {
        case let .matchingProgress(nicknames, tmis, onethings):
            newState.nicknames = nicknames
            newState.tmis = tmis
            newState.onethings = onethings
        case let .updateIsMeetingEnded(isMeetingEnded):
            newState.isMeetingEnded = isMeetingEnded
        }
        return newState
    }
}

private extension InMeetingStore {
    
    func matchingProgress() async -> OTProcessResult<Process> {
        
        do {
            let matchingProgressInfo = try await self.getMatchingsUseCase.matchingsProgress(
                type: self.matchingType,
                with: self.matchingId
            )
            return .single(
                .matchingProgress(
                    matchingProgressInfo.nicknameList,
                    matchingProgressInfo.tmiList,
                    matchingProgressInfo.nicknameOnethingMap
                        .enumerated()
                        .map { index, element in
                            OnethingInfo(
                                number: index+1,
                                category: element.key,
                                message: element.value
                            )
                        }
                )
            )
        } catch {
            return .single(.matchingProgress([], [], []))
        }
    }
    
    func meetingEnded() async -> OTProcessResult<Process> {
        
        do {
            let isMeetingEnded = try await self.updateMatchingsStatusUseCase.matchingsEnded(
                type: self.matchingType,
                with: self.matchingId
            )
            return .single(.updateIsMeetingEnded(isMeetingEnded))
        } catch {
            return .single(.updateIsMeetingEnded(false))
        }
    }

}

