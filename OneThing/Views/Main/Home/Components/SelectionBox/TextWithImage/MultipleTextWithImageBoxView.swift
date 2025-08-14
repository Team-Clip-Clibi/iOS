//
//  MultipleTextWithImageBoxView.swift
//  OneThing
//
//  Created by 오현식 on 5/20/25.
//

import SwiftUI

struct MultipleTextWithImageBoxView<T: SelectableItem>: View {
    
    let viewType: TextWithImageBoxStyle.ViewType
    let matrixs: [GridItem]
    
    private var axis: Axis.Set {
        return self.viewType == .matching ? .vertical: .horizontal
    }
    
    @State var state: SelectionState<T>
    @Binding var isReachedLimit: Bool
    @Binding var isSelected: Bool
    @Binding var selectedItems: [T]
    
    var body: some View {
        
        ScrollView(self.axis, showsIndicators: false) {
            switch self.viewType {
            case .matching:
                LazyVGrid(columns: self.matrixs, spacing: 10) {
                    ForEach(self.state.items.indices, id: \.self) { index in
                        let imageResource = (self.state.items[index].item as? OneThingCategory)?
                            .imageResource ?? .apple
                        
                        Toggle(
                            self.state.items[index].displayText,
                            isOn: $state.items[index].isSelected
                        )
                        .toggleStyle(
                            TextWithImageBoxStyle(
                                viewType: self.viewType,
                                imageResource: imageResource,
                                backgroundTapAction: { config in
                            
                                    self.backgroundTapped(config, index: index)
                                }
                            )
                        )
                    }
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
            case .meeting:
                LazyHGrid(rows: self.matrixs, spacing: 15) {
                    ForEach(self.state.items.indices, id: \.self) { index in
                        let selected = (self.state.items[index].item as? MeetingReviewMood)?
                            .selectedImageResource ?? .apple
                        let unSelected = (self.state.items[index].item as? MeetingReviewMood)?
                            .unSelectedImageResource ?? .apple
                        
                        Toggle(
                            self.state.items[index].displayText,
                            isOn: $state.items[index].isSelected
                        )
                        .toggleStyle(
                            TextWithImageBoxStyle(
                                viewType: .meeting,
                                imageResource: self.state.items[index].isSelected ? selected: unSelected,
                                backgroundTapAction: { config in
                                    
                                    self.backgroundTapped(config, index: index)
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
}

extension MultipleTextWithImageBoxView {
    
    private func backgroundTapped(_ config: ToggleStyle.Configuration, index: Int) {
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
    MultipleTextWithImageBoxView<OneThingCategory>(
        viewType: .matching,
        matrixs: [GridItem(), GridItem(), GridItem()],
        state: .init(
            items: OneThingCategory.allCases.map { .init(item: $0) },
            selectionLimit: 2
        ),
        isReachedLimit: .constant(false),
        isSelected: .constant(false),
        selectedItems: .constant([])
    )
    
    MultipleTextWithImageBoxView<MeetingReviewMood>(
        viewType: .meeting,
        matrixs: [GridItem()],
        state: .init(
            items: MeetingReviewMood.allCases.map { .init(item: $0) },
            selectionLimit: 1,
            changeWhenIsReachedLimit: true
        ),
        isReachedLimit: .constant(false),
        isSelected: .constant(false),
        selectedItems: .constant([])
    )
}
