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
            let id = UUID()
            let matchingDate: (String, String)
            let matchingTime: String
            var isSelected: Bool = false
        }
        
        var items: [SelectionItem]
        var selectLimit: Int = .max
        
        var selectedCount: Int {
            return self.items.filter { $0.isSelected }.count
        }
        var selectedItems: [SelectionItem] {
            return self.items.filter { $0.isSelected }
        }
        var willReachedLimit: Bool {
            return self.selectedCount >= self.selectLimit
        }
        var didReachedLimit: Bool {
            return self.selectedCount > self.selectLimit
        }
        
        var isSelected: Bool {
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
                                
                                // 선택할 뷰이면서 선택 제한에 도달할 때
                                if self.state.items[index].isSelected == false, self.state.willReachedLimit {
                                    self.isReachedLimit = true
                                    return
                                }
                                
                                config.isOn.toggle()
                                self.isReachedLimit = false
                                
                                self.isSelected = self.state.isSelected
                                self.selectedDates = self.state.selectedItems.map {
                                    "\($0.matchingDate.0)(\($0.matchingDate.1))"
                                }
                            }
                        )
                    )
                }
                .onChange(of: self.selectedDates) { _, new in
                    self.syncSelectionState(with: new)
                }
            }
        }
    }
    
    private func syncSelectionState(with selectedDates: [String]) {
        self.state.items.indices.forEach { index in
            let matchingDateString = self.state.items[index].matchingDate
            let dateString = "\(matchingDateString.0)(\(matchingDateString.1))"
            self.state.items[index].isSelected = selectedDates.contains(dateString)
        }
        
        self.isSelected = self.state.isSelected
        self.isReachedLimit = self.state.didReachedLimit
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
            lhs.isSelected == rhs.isSelected
    }
}

#Preview {
    MultipleDateTextBoxView(
        state: .init(
            items: Date().findWeekendDates().map { .init(matchingDate: $0, matchingTime: "디너 7시") },
            selectLimit: 2
        ),
        isReachedLimit: .constant(false),
        isSelected: .constant(false),
        selectedDates: .constant([])
    )
    .padding(.leading, 16)
}
