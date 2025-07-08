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
        fileprivate(set) var matchingId: String
        fileprivate(set) var matchingType: MatchingType
        fileprivate(set) var nicknames: [String]
        fileprivate(set) var quizs: [String]
        fileprivate(set) var onethings: [OnethingInfo]
        fileprivate(set) var isMeetingEnded: Bool
        
        var onethingCount: Int { return self.onethings.count }
    }
    
    let initalState: State
    var currentState: State
    
    let editMeetingEndUseCase: EditMeetingEndUseCase
    
    init(
        editMeetingEndUseCase: EditMeetingEndUseCase = EditMeetingEndUseCase(),
        inMeetingInfo: InMeetingInfo
    ) {
        self.editMeetingEndUseCase = editMeetingEndUseCase
        
        let onethingInfos = inMeetingInfo.oneThingMap.enumerated().map { index, element in
            OnethingInfo(number: index+1, category: element.key, message: element.value)
        }
        
        self.initalState = State(
            matchingId: inMeetingInfo.matchingId,
            matchingType: inMeetingInfo.matchingType,
            nicknames: inMeetingInfo.nicknameList,
            quizs: inMeetingInfo.quizList,
            onethings: onethingInfos,
            isMeetingEnded: false
        )
        self.currentState = self.initalState
    }
    
    }
}
