//
//  RefreshTokenDTO.swift
//  OneThing
//
//  Created by 윤동주 on 5/3/25.
//

import Foundation

struct RefreshTokenDTO: Encodable {
    var refreshToken: String
}

struct RefreshTokenResponse: Decodable {
    var accessToken: String
}
