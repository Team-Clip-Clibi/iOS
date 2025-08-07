//
//  OneThingMatchingViewModel.swift
//  OneThing
//
//  Created by 오현식 on 5/27/25.
//

import Foundation

@Observable
class OneThingMatchingViewModel {
    
    struct State: Equatable {
        var selectedCategory: [OneThingCategory]
        var topicContent: String
        var selectedDistrict: [District]
        var selectedBudgetRange: [BudgetRange]
        var tmiContent: String
        var selectedDates: [String]
    }
    var currentState: State
    
    init() {
        self.currentState = .init(
            selectedCategory: [],
            topicContent: "",
            selectedDistrict: [],
            selectedBudgetRange: [],
            tmiContent: "",
            selectedDates: []
        )
    }
    
    func initializeState(_ path: OTHomePath.OnethingMatching) {
        switch path {
        case .category:
            self.currentState.selectedCategory = []
        case .topic:
            self.currentState.topicContent = ""
        case .location:
            self.currentState.selectedDistrict = []
        case .price:
            self.currentState.selectedBudgetRange = []
        case .tmi:
            self.currentState.tmiContent = ""
        case .date:
            self.currentState.selectedDates = []
        default:
            break
        }
    }
    
    func removeSelectedDate(_ date: String) {
        self.currentState.selectedDates.removeAll { $0 == date }
    }
}
