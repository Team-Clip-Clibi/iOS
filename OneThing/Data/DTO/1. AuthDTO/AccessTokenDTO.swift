//
//  AccessTokenDTO.swift
//  OneThing
//
//  Created by 윤동주 on 7/31/25.
//

import Foundation

struct AccessTokenDTO {
    let accessToken: String
}

extension AccessTokenDTO: Codable {
    
    init(from decoder: any Decoder) throws {
        let singleContainer = try decoder.singleValueContainer()
        self.accessToken = try singleContainer.decode(String.self)
    }
}
