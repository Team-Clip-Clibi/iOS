//
//  NotificationInfo.swift
//  OneThing
//
//  Created by 오현식 on 5/9/25.
//

import Foundation

struct NotificationInfo: Equatable {
    
    enum Category: String {
        case meeting = "MEETING"
        case event = "EVENT"
        case notice = "NOTICE"
    }
    
    let id: String
    let notificationType: Category
    let content: String
    let createdAt: Date
}

// TODO: DTO 모델이 불필요
extension NotificationInfo: Codable {
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.notificationType = try container.decode(Category.self, forKey: .notificationType)
        self.content = try container.decode(String.self, forKey: .content)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
    }
}
extension NotificationInfo.Category: Codable { }
