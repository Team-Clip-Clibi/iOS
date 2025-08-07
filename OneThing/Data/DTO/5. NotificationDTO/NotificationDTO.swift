//
//  NotificationDTO.swift
//  OneThing
//
//  Created by 오현식 on 5/9/25.
//

import Foundation

struct NotificationDTO {
    let notificationInfos: [NotificationInfo]
}

extension NotificationDTO: Codable {
    
    init(from decoder: any Decoder) throws {
        let singleContainer = try decoder.singleValueContainer()
        self.notificationInfos = try singleContainer.decode([NotificationInfo].self)
    }
}
