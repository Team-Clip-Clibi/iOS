//
//  MultipleTextWithImageBoxView.swift
//  OneThing
//
//  Created by 오현식 on 5/20/25.
//

import SwiftUI

struct MultipleTextWithImageBoxView<T: SelectableItem>: View {

    struct SelectionState {
        
        struct SelectionItem: Identifiable, Equatable {
            let id = UUID()
            let item: T
            var isSelected: Bool = false
            
            var displayText: String {
                return self.item.displayText
            }
        }
        
        var items: [SelectionItem]
        var selectLimit: Int = .max
        
        var selectedCount: Int {
            return self.items.filter { $0.isSelected }.count
        }
        var selectedItems: [T] {
            return self.items.filter { $0.isSelected }.map { $0.item }
        }
        var willReachedLimit: Bool {
            return self.selectedCount >= self.selectLimit
        }
        
        var isSelected: Bool {
            return self.selectedCount > 0
        }
    }
    
    let viewType: TextWithImageBoxStyle.ViewType
    let matrixs: [GridItem]
    
    private var axis: Axis.Set {
        return self.viewType == .matching ? .vertical: .horizontal
    }
    
    @State var state: SelectionState
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
                            
                                    // 선택할 뷰이면서 선택 제한에 도달할 때
                                    if self.state.items[index].isSelected == false, self.state.willReachedLimit {
                                        self.isReachedLimit = true
                                        return
                                    }
                                    
                                    config.isOn.toggle()
                                    self.isReachedLimit = false
                                    
                                    self.isSelected = self.state.isSelected
                                    self.selectedItems = self.state.selectedItems
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
                        let selected = (self.state.items[index].item as? MeetingReviewInfo)?
                            .selectedImageResource ?? .apple
                        let unSelected = (self.state.items[index].item as? MeetingReviewInfo)?
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
                                    
                                    // 선택할 뷰이면서 선택 제한에 도달할 때
                                    if self.state.items[index].isSelected == false, self.state.willReachedLimit {
                                        self.isReachedLimit = true
                                        return
                                    }
                                    
                                    config.isOn.toggle()
                                    self.isReachedLimit = false
                                    
                                    self.isSelected = self.state.isSelected
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
}

#Preview {
    MultipleTextWithImageBoxView<OneThingCategory>(
        viewType: .matching,
        matrixs: [GridItem(), GridItem(), GridItem()],
        state: .init(
            items: OneThingCategory.allCases.map { .init(item: $0) },
            selectLimit: 1
        ),
        isReachedLimit: .constant(false),
        isSelected: .constant(false),
        selectedItems: .constant([])
    )
    
    MultipleTextWithImageBoxView<MeetingReviewInfo>(
        viewType: .meeting,
        matrixs: [GridItem()],
        state: .init(
            items: MeetingReviewInfo.allCases.map { .init(item: $0) },
            selectLimit: 1
        ),
        isReachedLimit: .constant(false),
        isSelected: .constant(false),
        selectedItems: .constant([])
    )
}
