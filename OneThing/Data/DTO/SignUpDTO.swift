//
//  SignUpDTO.swift
//  OneThing
//
//  Created by 윤동주 on 3/22/25.
//

import Foundation

struct SignUpDTO: Encodable {
    var servicePermission: Bool
    var privatePermission: Bool
    var marketingPermission: Bool
    var socialId: String
    var platform: String
    var deviceType = DeviceType.iOS.rawValue
    var osVersion: String
    var firebaseToken: String
    var isAllowNotify: Bool
}

struct SignUpResponse: Decodable {
    let accessToken: String
    let refreshToken: String
}
