//
//  MyMatchingInfo.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct MyMatchingInfo: Equatable {
    let job: JobType
    let relationshipStatus: RelationshipStatus
    let dietaryOption: String
    let language: String
}

extension MyMatchingInfo: Codable { }
