//
//  RandomOrder.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct RandomOrderRequest: Equatable {
    let topic: String
    let tmiContent: String
    let district: District
}

extension RandomOrderRequest: Codable { }
