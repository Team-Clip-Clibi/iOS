//
//  RandomMatchingViewModel.swift
//  OneThing
//
//  Created by 오현식 on 5/15/25.
//

import Foundation

@Observable
class RandomMatchingViewModel {
    
    struct State: Equatable {
        var selectedDistrict: [District]
        var topicContent: String
        var tmiContent: String
        
        var topicLength: Int {
            return self.topicContent.count
        }
        var tmiLength: Int {
            return self.tmiContent.count
        }
    }
    
    var currentState: State
    
    init() {
        self.currentState = .init(
            selectedDistrict: [],
            topicContent: "",
            tmiContent: ""
        )
    }
    
    func initializeState(_ path: OTHomePath.RandomMatching) {
        switch path {
        case .location:
            self.currentState.selectedDistrict = []
        case .topic:
            self.currentState.topicContent = ""
        case .tmi:
            self.currentState.tmiContent = ""
        default:
            break
        }
    }
}
