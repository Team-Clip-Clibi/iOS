//
//  SelectableItem.swift
//  OneThing
//
//  Created by 오현식 on 5/25/25.
//

import SwiftUI

protocol SelectableItem: Identifiable, Equatable {
    var displayText: String { get }
}

extension JobType: SelectableItem {
    var displayText: String {
        return self.toKorean
    }
}

extension DietaryType: SelectableItem {
    var displayText: String {
        return self.toKorean
    }
}

extension Language: SelectableItem{
    var displayText: String {
        return self.toKorean
    }
}

extension OneThingCategory: SelectableItem {
    var displayText: String {
        return self.toKorean
    }
}

extension MeetingReviewInfo: SelectableItem {
    var displayText: String {
        return self.toKorean
    }
}

extension AttendeesInfo: SelectableItem {
    var displayText: String {
        return self.toKorean
    }
}

extension District: SelectableItem {
    var displayText: String {
        return self.toKorean
    }
}

extension BudgetRange: SelectableItem {
    var displayText: String {
        return self.toKorean
    }
}

extension MemberInfo: SelectableItem {
    var displayText: String {
        return self.member
    }
}

extension NegativePoint: SelectableItem {
    var displayText: String {
        return self.toKorean
    }
}

extension PositivePoint: SelectableItem {
    var displayText: String {
        return self.toKorean
    }   
}
