//
//  SelectionState.swift
//  OneThing
//
//  Created by 오현식 on 6/29/25.
//

import Foundation

struct SelectionState<T: SelectableItem> {
    
    struct SelectionItem: Identifiable, Equatable {
        let id: String = UUID().uuidString
        let item: T
        var isSelected: Bool = false
        var isLastSelected: Bool = false
        
        var displayText: String {
            return self.item.displayText
        }
    }
    
    var items: [SelectionItem]
    var selectionLimit: Int = .max
    // 선택 제한에 도달 했을 때, 선택 변경 여부
    var changeWhenIsReachedLimit: Bool = false
    
    var selectedCount: Int {
        return self.items.filter { $0.isSelected }.count
    }
    var selectedItems: [T] {
        return self.items.filter { $0.isSelected }.map { $0.item }
    }
    
    var willReachedLimit: Bool {
        return self.selectedCount >= self.selectionLimit
    }
    
    var hasSelected: Bool {
        return self.selectedCount > 0
    }
}
