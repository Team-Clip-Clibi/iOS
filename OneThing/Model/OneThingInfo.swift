//
//  OneThingInfo.swift
//  OneThing
//
//  Created by 오현식 on 6/4/25.
//

import SwiftUI

struct OneThingInfo {
    let number: Int
    let category: String
    let message: String
    
    var backgroundColor: Color {
        switch self.number {
        case 1: return .orange100
        case 2: return .green100
        case 3: return .blue100
        case 4: return .yellow100
        case 5: return .purple200
        case 6: return .coral100
        case 7: return .mint100
        case 8: return .pink100
        default: return .white100
        }
    }
}

extension OneThingInfo {
    
    static let mock: [OneThingInfo] = [
        OneThingInfo(number: 1, category: "여행 · 취미", message: "혼자 유럽 여행 다니시는 분 있나요? 유럽 여행기 대화 나눠요. 유럽 여행기 대화 나눠요."),
        OneThingInfo(number: 2, category: "여행 · 취미", message: "혼자 유럽 여행 다니시는 분 있나요? 유럽 여행기 대화 나눠요. 유럽 여행기 대화 나눠요."),
        OneThingInfo(number: 3, category: "여행 · 취미", message: "혼자 유럽 여행 다니시는 분 있나요? 유럽 여행기 대화 나눠요. 유럽 여행기 대화 나눠요."),
        OneThingInfo(number: 4, category: "여행 · 취미", message: "혼자 유럽 여행 다니시는 분 있나요? 유럽 여행기 대화 나눠요. 유럽 여행기 대화 나눠요."),
        OneThingInfo(number: 5, category: "여행 · 취미", message: "혼자 유럽 여행 다니시는 분 있나요? 유럽 여행기 대화 나눠요. 유럽 여행기 대화 나눠요."),
        OneThingInfo(number: 6, category: "여행 · 취미", message: "혼자 유럽 여행 다니시는 분 있나요? 유럽 여행기 대화 나눠요. 유럽 여행기 대화 나눠요."),
        OneThingInfo(number: 7, category: "여행 · 취미", message: "혼자 유럽 여행 다니시는 분 있나요? 유럽 여행기 대화 나눠요. 유럽 여행기 대화 나눠요."),
        OneThingInfo(number: 8, category: "여행 · 취미", message: "혼자 유럽 여행 다니시는 분 있나요? 유럽 여행기 대화 나눠요. 유럽 여행기 대화 나눠요.")
    ]
}
