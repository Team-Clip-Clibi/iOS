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
    
    let locations = ["홍대/합정", "강남"]
    let prices = ["10,000~30,000원", "30,000~50,000원", "50,000~70,000원"]
    
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
