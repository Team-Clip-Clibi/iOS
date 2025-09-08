//
//  ApplicationInfo.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct ApplicationInfo: Equatable {
    let district: String
    let preferredDates: [PreferredDate]?
    let oneThingBudgetRange: BudgetRange?
    let oneThingCategory: OneThingCategory?
}

extension ApplicationInfo: Codable {
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.district = try container.decode(String.self, forKey: .district)
        self.preferredDates = try container.decodeIfPresent([PreferredDate].self, forKey: .preferredDates)
        self.oneThingBudgetRange = try container.decodeIfPresent(BudgetRange.self, forKey: .oneThingBudgetRange)
        self.oneThingCategory = try container.decodeIfPresent(OneThingCategory.self, forKey: .oneThingCategory)
    }
}
