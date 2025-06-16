//
//  SelectableItem.swift
//  OneThing
//
//  Created by 오현식 on 5/25/25.
//

import SwiftUI

protocol SelectableItem: Identifiable, Equatable, CaseIterable {
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
