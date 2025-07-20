//
//  NegativePoint.swift
//  OneThing
//
//  Created by 오현식 on 6/29/25.
//

import Foundation

enum NegativePoint: Codable, CaseIterable, Identifiable {
    
    case conversationWasBoring
    case membersWerePassive
    case progressWasDifficultToUnderstand
    case atmosphereWasAwkwardOrUncomfortable
    case doNotLikeTimeAndPlace
    case notkeepingAppointment
    
    var id: String { UUID().uuidString }
    
    var toKorean: String {
        switch self {
        case .conversationWasBoring:
            return "대화가 지루했어요"
        case .membersWerePassive:
            return "멤버들이 소극적이었어요"
        case .progressWasDifficultToUnderstand:
            return "진행이 이해하기 어려웠어요"
        case .atmosphereWasAwkwardOrUncomfortable:
            return "분위기가 어색하거나 불편했어요"
        case .doNotLikeTimeAndPlace:
            return "시간과 장소가 마음에 안들어요"
        case .notkeepingAppointment:
            return "약속 시간을 지키지 않은 멤버가 많았어요"
        }
    }
}
