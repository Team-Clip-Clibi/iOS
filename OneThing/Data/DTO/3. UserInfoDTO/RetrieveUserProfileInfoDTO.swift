//
//  RetrieveUserProfileInfo.swift
//  OneThing
//
//  Created by 윤동주 on 3/23/25.
//

import Foundation

struct RetrieveUserProfileInfoDTO: Codable {
    var username: String
    var platform: String
    var phoneNumber: String
    var nickname: String?
}

extension RetrieveUserProfileInfoDTO {
    func toDomain() -> UserProfileInfo {
        return UserProfileInfo(
            username: username,
            platform: platform,
            phoneNumber: phoneNumber,
            nickname: nickname ?? "없음"
        )
    }
}
