//
//  MultipleDateTextBoxView.swift
//  OneThing
//
//  Created by 오현식 on 5/20/25.
//

import SwiftUI

struct MultipleDateTextBoxView: View {
    
    struct SelectionState {
        
        struct SelectionItem: Identifiable {
            let id: String = UUID().uuidString
            let matchingDate: (String, String)
            let matchingTime: String
            var isSelected: Bool = false
            var isLastSelected: Bool = false
        }
        
        var items: [SelectionItem]
        var selectLimit: Int = .max
        // 선택 제한에 도달 했을 때, 선택 변경 여부
        var changeWhenIsReachedLimit: Bool = false
        
        var selectedCount: Int {
            return self.items.filter { $0.isSelected }.count
        }
        var selectedDates: [String] {
            return self.items
                .filter { $0.isSelected }
                .map { "\($0.matchingDate.0)(\($0.matchingDate.1))" }
        }
        var willReachedLimit: Bool {
            return self.selectedCount >= self.selectLimit
        }
        
        var hasSelected: Bool {
            return self.selectedCount > 0
        }
    }
    
    @State var state: SelectionState
    @Binding var isReachedLimit: Bool
    @Binding var isSelected: Bool
    @Binding var selectedDates: [String]
    
    let rows = [GridItem()]
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: self.rows, spacing: 10) {
                ForEach(self.state.items.indices, id: \.self) { index in
                    Toggle(
                        self.state.items[index].matchingTime,
                        isOn: $state.items[index].isSelected
                    )
                    .toggleStyle(
                        DateTextBoxStyle(
                            matchingDate: self.state.items[index].matchingDate,
                            backgroundTapAction: { config in
                                
                                // 이미 선택된 항목을 재선택할 때
                                if config.isOn {
                                    self.isReachedLimit = false
                                } else {
                                    // 선택 제한에 도달 했을 때, 선택 막음
                                    if self.handleSelectionLimit() == false { return }
                                }
                                
                                config.isOn.toggle()
                                
                                self.updateLastSelectedItem(at: index)
                                self.isSelected = self.state.hasSelected
                                self.selectedDates = self.state.selectedDates
                            }
                        )
                    )
                }
            }
        }
    }
}

extension MultipleDateTextBoxView {
    
    private func updateLastSelectedItem(at index: Int) {
        // 마지막으로 선택된 항목의 인덱스 찾기
        if let lastIndex = self.state.items.firstIndex(where: { $0.isLastSelected }) {
            self.state.items[lastIndex].isLastSelected = false
        }
        // 현재 항목을 마지막 선택된 항목으로 변경
        self.state.items[index].isLastSelected = true
    }
    
    private func handleSelectionLimit() -> Bool {
        // 선택 제한에 도달 했을 때
        guard self.state.willReachedLimit else { return true }
        // 제한 도달 여부 변경
        self.isReachedLimit = true
        // 선택된 항목으로 변경 X
        guard self.state.changeWhenIsReachedLimit else { return false }
        // 마지막으로 선택된 항목의 인덱스 찾기
        if let lastIndex = self.state.items.firstIndex(where: { $0.isLastSelected }) {
            self.state.items[lastIndex].isLastSelected = false
            // 마지막으로 선택된 항목 해제
            self.state.items[lastIndex].isSelected = false
        }
        
        return true
    }
}

extension MultipleDateTextBoxView.SelectionState.SelectionItem: Equatable {
    
    static func == (
        lhs: MultipleDateTextBoxView.SelectionState.SelectionItem,
        rhs: MultipleDateTextBoxView.SelectionState.SelectionItem
    ) -> Bool {
        return lhs.id == rhs.id &&
            lhs.matchingDate == rhs.matchingDate &&
            lhs.matchingTime == rhs.matchingTime &&
            lhs.isSelected == rhs.isSelected &&
            lhs.isLastSelected == rhs.isLastSelected
    }
}

#Preview {
    MultipleDateTextBoxView(
        state: .init(
            items: Date().findWeekendDates().map { .init(matchingDate: $0, matchingTime: "디너 7시") },
            selectLimit: 2,
            changeWhenIsReachedLimit: true
        ),
        isReachedLimit: .constant(false),
        isSelected: .constant(false),
        selectedDates: .constant([])
    )
    .padding(.leading, 16)
}
