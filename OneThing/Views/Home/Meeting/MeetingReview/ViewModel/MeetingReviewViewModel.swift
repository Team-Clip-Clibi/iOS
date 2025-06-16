//
//  MeetingReviewViewModel.swift
//  OneThing
//
//  Created by 오현식 on 6/10/25.
//

import SwiftUI

@Observable
class MeetingReviewViewModel {
    
    struct State: Equatable {
        private(set) var selectedPositivePoints: [String]
        private(set) var selectedNegativePoints: [String]
    }
    var currentState: State
    
    let positivePotintsContents = [
        "대화가 흥미로웠어요",
        "멤버들이 적극적으로 참여했어요",
        "진행이 매끄러웠어요",
        "분위기가 편안하고 즐거웠어요",
        "시간과 장소가 적절했어요"
    ]
    let negativePointsContents = [
        "대화가 지루했어요",
        "멤버들이 소극적이었어요",
        "진행이 이해하기 어려웠어요",
        "분위기가 어색하거나 불편했어요",
        "시간과 장소가 마음에 안들어요",
        "약속 시간을 지키지 않은 멤버가 많았어요"
    ]
    // TODO: 임시, 모임 닉네임 조회 필요
    let members = ["미도리아", "바쿠고", "우라라카", "올마이트"]
    
    init() {
        self.currentState = .init(
            selectedPositivePoints: [],
            selectedNegativePoints: []
        )
    }
}
