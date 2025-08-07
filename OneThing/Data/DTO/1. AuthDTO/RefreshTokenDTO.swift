//
//  RefreshTokenDTO.swift
//  OneThing
//
//  Created by 윤동주 on 7/31/25.
//

import Foundation


struct RefreshTokenDTO {
    let refreshToken: String
}

extension RefreshTokenDTO: Codable {
    
    init(from decoder: any Decoder) throws {
        let singleContainer = try decoder.singleValueContainer()
        self.refreshToken = try singleContainer.decode(String.self)
    }
}
