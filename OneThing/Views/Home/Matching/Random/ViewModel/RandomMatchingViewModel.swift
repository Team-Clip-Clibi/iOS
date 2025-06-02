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
        var selectedLocations: [String]
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
    
    let locations = ["홍대/합정", "강남"]
    
    init() {
        self.currentState = .init(
            selectedLocations: [],
            topicContent: "",
            tmiContent: ""
        )
    }
    
    func initializeState(_ path: OTHomePath.RandomMatching) {
        switch path {
        case .location:
            self.currentState.selectedLocations = []
        case .topic:
            self.currentState.topicContent = ""
        case .tmi:
            self.currentState.tmiContent = ""
        default:
            break
        }
    }
}
