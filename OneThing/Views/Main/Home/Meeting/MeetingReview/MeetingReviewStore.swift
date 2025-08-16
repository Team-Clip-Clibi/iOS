//
//  MeetingReviewStore.swift
//  OneThing
//
//  Created by 오현식 on 8/10/25.
//

import Foundation

@Observable
class MeetingReviewStore: OTStore {
    
    enum Action: OTAction {
        case submit(
            mood: MeetingReviewMood,
            positivePoints: [String],
            negativePoints: [String],
            reviewContent: String,
            noShowMembers: [String],
            isMemberAllAttended: Bool
        )
    }
    
    enum Process: OTProcess {
        case updateIsSubmit(Bool)
    }
    
    struct State: OTState {
        fileprivate(set) var isSubmit: Bool
    }
    var state: State
    
    let submitMeetingReviewUseCase: SubmitMeetingReviewUseCase
    
    let initalInfo: InitialInfo
    
    let positivePotintsContents = [
        "대화가 흥미로웠어요",
        "멤버들이 적극적으로 참여했어요",
        "진행이 매끄러웠어요",
        "분위기가 편안하고 즐거웠어요",
        "시간과 장소가 적절했어요"
    ]
    let negativePointsContents = [
        "대화가 지루했어요",
        "멤버들이 소극적이었어요",
        "진행이 이해하기 어려웠어요",
        "분위기가 어색하거나 불편했어요",
        "시간과 장소가 마음에 안들어요",
        "약속 시간을 지키지 않은 멤버가 많았어요"
    ]
    
    init(
        submitMeetingReviewUseCase: SubmitMeetingReviewUseCase,
        initalInfo: InitialInfo
    ) {
        
        self.state = State(isSubmit: false)
        
        self.submitMeetingReviewUseCase = submitMeetingReviewUseCase
        
        self.initalInfo = initalInfo
    }
    
    func process(_ action: Action) async -> OTProcessResult<Process> {
        switch action {
        case let .submit(
            mood,
            positivePoints,
            negativePoints,
            reviewContent,
            noShowMembers,
            isMemberAllAttended
        ):
            return await self.submit(
                mood: mood,
                positivePoints: positivePoints,
                negativePoints: negativePoints,
                reviewContent: reviewContent,
                noShowMembers: noShowMembers,
                isMemberAllAttended: isMemberAllAttended
            )
        }
    }
    
    func reduce(state: State, process: Process) -> State {
        var newState = state
        switch process {
        case let .updateIsSubmit(isSubmit):
            newState.isSubmit = isSubmit
        }
        return newState
    }
}

private extension MeetingReviewStore {
    
    func submit(
        mood: MeetingReviewMood,
        positivePoints: [String],
        negativePoints: [String],
        reviewContent: String,
        noShowMembers: [String],
        isMemberAllAttended: Bool
    ) async -> OTProcessResult<Process> {
        do {
            let isSubmit = try await self.submitMeetingReviewUseCase.execute(
                mood: mood,
                positivePoints: positivePoints.joined(separator: ", "),
                negativePoints: negativePoints.joined(separator: ", "),
                reviewContent: reviewContent,
                noShowMembers: noShowMembers.joined(separator: ", "),
                isMemberAllAttended: isMemberAllAttended,
                matchingId: self.initalInfo.matchingId,
                matchingType: self.initalInfo.matchingtype
            )
            // 작성된 모임 리뷰 UserDefaults에서 제거
            SimpleDefaults.shared.removeRecentMatchings([self.initalInfo.matchingId], with: .review)
            
            return .single(.updateIsSubmit(isSubmit))
        } catch {
            
            return .single(.updateIsSubmit(false))
        }
    }
}

extension MeetingReviewStore {
    
    struct InitialInfo: Equatable, Hashable {
        let nicknames: [String]
        let matchingId: String
        let matchingtype: MatchingType
        
        init() {
            self.nicknames = []
            self.matchingId = ""
            self.matchingtype = .onething
        }
        
        init(nicknames: [String], matchingId: String, matchingtype: MatchingType) {
            self.nicknames = nicknames
            self.matchingId = matchingId
            self.matchingtype = matchingtype
        }
    }
}
