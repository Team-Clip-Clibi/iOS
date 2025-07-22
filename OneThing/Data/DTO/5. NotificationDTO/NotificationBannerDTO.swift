//
//  NotificationBannerDTO.swift
//  OneThing
//
//  Created by 오현식 on 5/13/25.
//

import Foundation

struct NotificationBannerDto {
    let notificationBannerInfos: [NotificationBannerInfo]
}

extension NotificationBannerDto: Codable {
    
    init(from decoder: any Decoder) throws {
        let singleContainer = try decoder.singleValueContainer()
        self.notificationBannerInfos = try singleContainer.decode([NotificationBannerInfo].self)
    }
}
