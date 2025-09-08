//
//  RelationshipInfo.swift
//  OneThing
//
//  Created by 윤동주 on 5/4/25.
//

import Foundation

struct RelationshipInfo: Equatable {
    var status: RelationshipStatus?
    var isConsidered: Bool?
}

extension RelationshipInfo: Codable { }
