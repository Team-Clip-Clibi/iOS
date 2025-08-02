//
//  RandomMatchingDuplicateCheckDTO.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct RandomMatchingDuplicateCheckDTO {
    let randomMatchingDuplicateCheckInfo: RandomMatchingDuplicateCheckInfo
}

extension RandomMatchingDuplicateCheckDTO: Codable {
    
    init(from decoder: any Decoder) throws {
        let singleContainer = try decoder.singleValueContainer()
        self.randomMatchingDuplicateCheckInfo = try singleContainer.decode(RandomMatchingDuplicateCheckInfo.self)
    }
}
