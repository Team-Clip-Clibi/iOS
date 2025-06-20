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
        fileprivate(set) var quizs: [String]
        fileprivate(set) var onethings: [OnethingInfo]?
        
        var onethingCount: Int {
            return self.onethings?.count ?? 0
        }
    }
    
    var currentState: State
    
    init(
        nicknames: [String],
        quizs: [String],
        onethings: [String: String]?
    ) {
        var onethingInfos: [OnethingInfo]?
        if let onethings = onethings {
            onethingInfos = onethings.enumerated().map { index, element in
                OnethingInfo(number: index+1, category: element.key, message: element.value)
            }
        } else {
            onethingInfos = nil
        }
        
        self.currentState = State(nicknames: nicknames, quizs: quizs, onethings: onethingInfos)
    }
}
