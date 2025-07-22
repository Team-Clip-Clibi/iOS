//
//  positivePoint.swift
//  OneThing
//
//  Created by 오현식 on 6/29/25.
//

import Foundation

enum PositivePoint: CaseIterable, Identifiable {
    
    case conversationWasInteresting
    case membersParticipatedActively
    case progressWasSmooth
    case atmosphereWasComfortableAndEnjoyable
    case timeAndPlaceWereRight
    
    var id: Self { self }
    
    var toKorean: String {
        switch self {
        case .conversationWasInteresting:
            return "대화가 흥미로웠어요"
        case .membersParticipatedActively:
            return "멤버들이 적극적으로 참여했어요"
        case .progressWasSmooth:
            return "진행이 매끄러웠어요"
        case .atmosphereWasComfortableAndEnjoyable:
            return "분위기가 편안하고 즐거웠어요"
        case .timeAndPlaceWereRight:
            return "시간과 장소가 적절했어요"
        }
    }
}

extension PositivePoint: Codable { }
