//
//  NoticeInfo.swift
//  OneThing
//
//  Created by 오현식 on 5/9/25.
//

import Foundation

struct NoticeInfo: Equatable {
    
    enum Category: String {
        case notice = "NOTICE"
        case article = "ARTICLE"
        
        var description: String {
            switch self {
            case .notice: return "공지"
            case .article: return "새소식"
            }
        }
    }
    
    let noticeType: Category
    let content: String
    let link: String
}

extension NoticeInfo: Codable {
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.noticeType = try container.decode(Category.self, forKey: .noticeType)
        self.content = try container.decode(String.self, forKey: .content)
        self.link = (try? container.decode(String.self, forKey: .link)) ?? ""
    }
}
extension NoticeInfo.Category: Codable { }
