//
//  NotificationDTO.swift
//  OneThing
//
//  Created by 오현식 on 5/9/25.
//

import Foundation

struct NotificationDTO: Codable {
    let notificationInfos: [NotificationInfo]
    
    init(from decoder: any Decoder) throws {
        let singleContainer = try decoder.singleValueContainer()
        self.notificationInfos = try singleContainer.decode([NotificationInfo].self)
    }
}
