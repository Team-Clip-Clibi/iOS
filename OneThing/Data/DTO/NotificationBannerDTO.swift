//
//  NotificationBannerDTO.swift
//  OneThing
//
//  Created by 오현식 on 5/13/25.
//

import Foundation

struct NotificationBannerDto: Codable {
    let notificationBannerInfo: [NotificationBannerInfo]
    
    init(from decoder: any Decoder) throws {
        let singleContainer = try decoder.singleValueContainer()
        self.notificationBannerInfo = try singleContainer.decode([NotificationBannerInfo].self)
    }
}
