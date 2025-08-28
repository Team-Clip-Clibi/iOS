//
//  NotificationBannerInfo.swift
//  OneThing
//
//  Created by 오현식 on 5/13/25.
//

import Foundation

struct NotificationBannerInfo: Equatable {
    enum Category: String {
        case matching = "MATCHING"
        case matchingInfo = "MATCHING_INFO"
        case review = "REVIEW"
        
        var title: String {
            switch self {
            case .matching:
                return "확인하기"
            case .matchingInfo:
                return "확인하기"
            case .review:
                return "후기 남기기"
            }
        }
        
        var description: String {
            switch self {
            case .matching:
                return "모임 매칭이 완료되었어요! 매칭 결과를 확인해요"
            case .matchingInfo:
                return "최종 안내문이 도착했어요! 지금 확인해 보세요"
            case .review:
                return "오늘 모임은 어떠셨나요? 후기를 남겨주세요"
            }
        }
    }
    
    let id: String
    let bannerType: Category
}

extension NotificationBannerInfo: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case bannerType = "notificationBannerType"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = "\(try container.decode(Int.self, forKey: .id))"
        self.bannerType = try container.decode(Category.self, forKey: .bannerType)
    }
}
extension NotificationBannerInfo.Category: Codable { }
