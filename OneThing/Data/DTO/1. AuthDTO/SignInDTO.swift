//
//  SignInDTO.swift
//  OneThing
//
//  Created by 윤동주 on 4/4/25.
//

import Foundation

struct SignInDTO: Encodable {
    var socialId: String
    var platform: String
    var deviceType = DeviceType.iOS.rawValue
    var osVersion: String
    var firebaseToken: String
    var isAllowNotify: Bool
}

struct SignInResponse: Decodable {
    let accessToken: String
    let refreshToken: String
}
