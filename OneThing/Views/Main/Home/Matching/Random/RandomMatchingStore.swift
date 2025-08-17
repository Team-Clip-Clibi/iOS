//
//  RandomMatchingStore.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import Foundation

@Observable
class RandomMatchingStore: OTStore {
    
    enum Action: OTAction {
        case updateDistrict(District?)
        case updateTopicContents(String)
        case updateTmiContents(String)
    }
    
    enum Process: OTProcess {
        case updateDistrict(District?)
        case updateTopicContents(String)
        case updateTmiContents(String)
    }
    
    struct State: OTState {
        fileprivate(set) var selectedDistrict: District?
        fileprivate(set) var topicContents: String
        fileprivate(set) var tmiContents: String
        
        var topicLength: Int {
            return self.topicContents.count
        }
        var tmiLength: Int {
            return self.tmiContents.count
        }
    }
    var state: State
    
    let nickname: String
    
    init(with nickname: String) {
        
        self.state = State(
            selectedDistrict: nil,
            topicContents: "",
            tmiContents: ""
        )
        
        self.nickname = nickname
    }
    
    func process(_ action: Action) async -> OTProcessResult<Process> {
        switch action {
        case let .updateDistrict(selectedDistrict):
            return .single(.updateDistrict(selectedDistrict))
        case let .updateTopicContents(topicContents):
            return .single(.updateTopicContents(topicContents))
        case let .updateTmiContents(tmiContents):
            return .single(.updateTmiContents(tmiContents))
        }
    }
    
    func reduce(state: State, process: Process) -> State {
        var newState = state
        switch process {
        case let .updateDistrict(selectedDistrict):
            newState.selectedDistrict = selectedDistrict
        case let .updateTopicContents(topicContents):
            newState.topicContents = topicContents
        case let .updateTmiContents(tmiContents):
            newState.tmiContents = tmiContents
        }
        return newState
    }
}
