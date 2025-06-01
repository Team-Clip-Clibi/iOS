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
            
            var imageResource: ImageResource? {
                return (self.item as? OneThingCategory)?.imageResource
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
    
    @State var state: SelectionState
    @Binding var isReachedLimit: Bool
    @Binding var isSelected: Bool
    @Binding var selectedItems: [T]
    
    let cols = [GridItem(), GridItem(), GridItem()]
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: self.cols, spacing: 10) {
                ForEach(self.state.items.indices, id: \.self) { index in
                    Toggle(
                        self.state.items[index].displayText,
                        isOn: $state.items[index].isSelected
                    )
                    .toggleStyle(
                        TextWithImageBoxStyle(
                            imageResource: self.state.items[index].imageResource ?? .health,
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

#Preview {
    MultipleTextWithImageBoxView<OneThingCategory>(
        state: .init(
            items: OneThingCategory.allCases.map { .init(item: $0) },
            selectLimit: 1
        ),
        isReachedLimit: .constant(false),
        isSelected: .constant(false),
        selectedItems: .constant([])
    )
}
