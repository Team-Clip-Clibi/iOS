//
//  MultipleOnlyTextBoxView.swift
//  OneThing
//
//  Created by 오현식 on 5/20/25.
//

import SwiftUI

struct MultipleOnlyTextBoxView<T: SelectableItem>: View {
    
    @State var state: SelectionState<T>
    @Binding var isReachedLimit: Bool
    @Binding var isSelected: Bool
    @Binding var selectedItems: [T]
    
    let cols: [GridItem]
    let alignment: Alignment
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: self.cols, spacing: 10) {
                ForEach(self.state.items.indices, id: \.self) { index in
                    Toggle(
                        self.state.items[index].displayText,
                        isOn: $state.items[index].isSelected
                    )
                    .toggleStyle(
                        OnlyTextBoxStyle(
                            alignment: self.alignment,
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
                                self.selectedItems = self.state.selectedItems
                            }
                        )
                    )
                }
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
        }
    }
}

extension MultipleOnlyTextBoxView {
    
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

#Preview {
    MultipleOnlyTextBoxView<JobType>(
        state: .init(
            items: JobType.allCases.map { .init(item: $0) },
            selectionLimit: 2,
            changeWhenIsReachedLimit: true
        ),
        isReachedLimit: .constant(false),
        isSelected: .constant(false),
        selectedItems: .constant([]),
        cols: [GridItem(), GridItem()],
        alignment: .center
    )
    
    MultipleOnlyTextBoxView<DietaryType>(
        state: .init(
            items: DietaryType.allCases.map { .init(item: $0) },
            selectionLimit: 1,
            changeWhenIsReachedLimit: true
        ),
        isReachedLimit: .constant(false),
        isSelected: .constant(false),
        selectedItems: .constant([]),
        cols: [GridItem()],
        alignment: .leading
    )
}
