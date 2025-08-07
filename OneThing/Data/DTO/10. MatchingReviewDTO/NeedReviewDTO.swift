//
//  NeedReviewDTO.swift
//  OneThing
//
//  Created by 윤동주 on 7/27/25.
//

import Foundation

struct NeedReviewDTO {
    let needReviewInfos: [NeedReviewInfo]
}

extension NeedReviewDTO: Codable {
    
    init(from decoder: any Decoder) throws {
        let singleContainer = try decoder.singleValueContainer()
        self.needReviewInfos = try singleContainer.decode([NeedReviewInfo].self)
    }
}
