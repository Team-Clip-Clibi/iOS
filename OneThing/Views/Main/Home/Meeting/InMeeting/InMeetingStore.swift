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
            // let matchingProgressInfo = try await self.getMatchingsUseCase.matchingsProgress(
            //     type: self.matchingType,
            //     with: self.matchingId
            // )
            return .single(
                .matchingProgress(
                    // matchingProgressInfo.nicknameList,
                    ["민만민", "미도리아", "바쿠고", "내이름은코난", "탐정이죠", "haeong", "햄햄", "흐으으음"],
                    // matchingProgressInfo.tmiList,
                    ["데이팅앱을 운영하고 있어요", "축구를 좋아해요", "영국 어학연수 가는 것이 목표에요", "제주도 스탭을 했었어요", "어릴 때 개그 극단 들어간 적 있어요", "축구를 좋아해요", "축구를 좋아해요", "축구를 좋아해요"],
                    // matchingProgressInfo.nicknameOnethingMap
                    //     .enumerated()
                    //     .map { index, element in
                    //         OnethingInfo(
                    //             number: index+1,
                    //             category: element.key,
                    //             message: element.value
                    //         )
                    //     }
                    [
                        OnethingInfo(number: 1, category: "여행·취미", message: "혼자 유럽 여행 다니시는 분 있나요? 유럽 여행기 대화 나눠요. 유럽 여행기 대화 나눠요."),
                        OnethingInfo(number: 2, category: "여행·취미", message: "혼자 유럽 여행 다니시는 분 있나요? 유럽 여행기 대화 나눠요. 유럽 여행기 대화 나눠요."),
                        OnethingInfo(number: 3, category: "여행·취미", message: "혼자 유럽 여행 다니시는 분 있나요? 유럽 여행기 대화 나눠요. 유럽 여행기 대화 나눠요."),
                        OnethingInfo(number: 4, category: "여행·취미", message: "혼자 유럽 여행 다니시는 분 있나요? 유럽 여행기 대화 나눠요. 유럽 여행기 대화 나눠요."),
                        OnethingInfo(number: 5, category: "여행·취미", message: "혼자 유럽 여행 다니시는 분 있나요? 유럽 여행기 대화 나눠요. 유럽 여행기 대화 나눠요."),
                        OnethingInfo(number: 6, category: "여행·취미", message: "혼자 유럽 여행 다니시는 분 있나요? 유럽 여행기 대화 나눠요. 유럽 여행기 대화 나눠요."),
                        OnethingInfo(number: 7, category: "여행·취미", message: "혼자 유럽 여행 다니시는 분 있나요? 유럽 여행기 대화 나눠요. 유럽 여행기 대화 나눠요."),
                        OnethingInfo(number: 8, category: "여행·취미", message: "혼자 유럽 여행 다니시는 분 있나요? 유럽 여행기 대화 나눠요. 유럽 여행기 대화 나눠요.")
                    ]
                )
            )
        } catch {
            return .single(.matchingProgress([], [], []))
        }
    }
    
    func meetingEnded() async -> OTProcessResult<Process> {
        
        do {
            // let isMeetingEnded = try await self.updateMatchingsStatusUseCase.matchingsEnded(
            //     type: self.matchingType,
            //     with: self.matchingId
            // )
            // 모임이 끝난 UserDefaults에서 제거
            // SimpleDefaults.shared.removeRecentMatchings([self.matchingId], with: .inMeeting)
            
            // return .single(.updateIsMeetingEnded(isMeetingEnded))
            return .single(.updateIsMeetingEnded(true))
        } catch {
            return .single(.updateIsMeetingEnded(false))
        }
    }

}

