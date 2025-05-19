//
//  MultipleCheckBoxView.swift
//  OneThing
//
//  Created by 오현식 on 5/14/25.
//

import SwiftUI

struct SelectionItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    var isSelected: Bool = false
}

struct SelectionState {
    
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
    
    var isSelected: Bool {
        return self.selectedCount > 0
    }
}

struct MultipleCheckBoxView: View {
    
    @State var state: SelectionState
    @Binding var isReachedLimit: Bool
    @Binding var isSelected: Bool
    @Binding var selectedTitles: [String]
    
    var body: some View {
        
        VStack(spacing: 10) {
            ForEach(self.state.items.indices, id: \.self) { index in
                Toggle(
                    self.state.items[index].title,
                    isOn: $state.items[index].isSelected
                )
                .padding(.horizontal, 16)
                .toggleStyle(SelectionBoxStyle(backgroundTapAction: { config in
                    
                    // 선택할 뷰이면서 선택 제한에 도달할 때
                    if self.state.items[index].isSelected == false, self.state.willReachedLimit {
                        self.isReachedLimit = true
                        return
                    }
                    
                    config.isOn.toggle()
                    self.isReachedLimit = false
                    
                    self.isSelected = self.state.isSelected
                    self.selectedTitles = self.state.selectedItems.map { $0.title }
                }))
            }
        }
    }
}
