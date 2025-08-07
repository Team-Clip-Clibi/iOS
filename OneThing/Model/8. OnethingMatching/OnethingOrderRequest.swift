//
//  OneThingOrderRequest.swift
//  OneThing
//
//  Created by 윤동주 on 6/17/25.
//

import Foundation

struct OnethingOrderRequest: Equatable {
    let topic: String
    let district: District
    let preferredDates: [PreferredDate]
    let tmiContent: String
    let oneThingBudgetRange: BudgetRange
    let oneThingCategory: OneThingCategory
}

extension OnethingOrderRequest: Codable { }
