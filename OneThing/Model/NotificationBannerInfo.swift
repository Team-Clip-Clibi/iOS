//
//  NotificationBannerInfo.swift
//  OneThing
//
//  Created by 오현식 on 5/13/25.
//

import Foundation

struct NotificationBannerInfo: Equatable {
    
    enum bannerType: String {
        case matching = "MATCHING"
        case matchingInfo = "MATCHING_INFO"
        case review = "REVIEW"
        
        var title: String {
            switch self {
            case .matching:
                return "참석 결정하기"
            case .matchingInfo:
                return "확인하기"
            case .review:
                return "후기 남기기"
            }
        }
        
        var description: String {
            switch self {
            case .matching:
                return "모임 매칭이 완료되었어요! 참석 여부를 알려주세요"
            case .matchingInfo:
                return "최종 안내문이 도착했어요! 지금 확인해 보세요"
            case .review:
                return "오늘 모임은 어떠셨나요? 리뷰를 남겨주세요"
            }
        }
    }
    
    let id: Int
    let type: bannerType
}

extension NotificationBannerInfo: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case type = "notificationBannerType"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.type = try container.decode(NotificationBannerInfo.bannerType.self, forKey: .type)
    }
}
extension NotificationBannerInfo.bannerType: Codable { }
