//
//  MyMeetingViewModel.swift
//  OneThing
//
//  Created by 윤동주 on 5/20/25.
//

import SwiftUI

@Observable
class MyMeetingStore: OTStore {
    
    enum Action: OTAction {
        case landing
        case matchings
    }
    
    enum Process: OTProcess {
        case nickname(String)
        case matchings([MatchingInfo])
    }
    
    struct State: OTState {
        fileprivate(set) var nickname: String
        fileprivate(set) var matchingInfo: [MatchingInfo]
    }
    var state: State

    private let getProfileUseCase: GetProfileInfoUseCase
    private let getMatchingsUseCase: GetMatchingsUseCase
    
    init(
        getProfileUseCase: GetProfileInfoUseCase,
        getMatchingsUseCase: GetMatchingsUseCase
    ) {
        
        self.state = State(nickname: "", matchingInfo: [])
        
        self.getProfileUseCase = getProfileUseCase
        self.getMatchingsUseCase = getMatchingsUseCase
    }
    
    func process(_ action: Action) async -> OTProcessResult<Process> {
        switch action {
        case .landing:
            return await self.nickname()
        case .matchings:
            return await self.matchings()
        }
    }
    
    func reduce(state: State, process: Process) -> State {
        var newState = state
        switch process {
        case let .nickname(nickname):
            newState.nickname = nickname
        case let .matchings(matchingInfos):
            newState.matchingInfo = matchingInfos
        }
        return newState
    }
}

private extension MyMeetingStore {
    
    func nickname() async -> OTProcessResult<Process> {
        do {
            let nickname = try await self.getProfileUseCase.execute().nickname
            return .single(.nickname(nickname))
        } catch {
            return .single(.nickname(""))
        }
    }
    
    func matchings() async -> OTProcessResult<Process> {
        do {
            let matchings = try await self.getMatchingsUseCase.matchings()
            
            return .single(.matchings(matchings))
        } catch {
            return .single(.matchings([]))
        }
    }
}
