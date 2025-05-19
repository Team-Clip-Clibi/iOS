//
//  BannerInfoDTO.swift
//  OneThing
//
//  Created by 오현식 on 5/10/25.
//

import Foundation

enum BannerInfoType: String {
    case home = "HOME"
    case login = "LOGIN"
}

struct BannerInfoDTO: Codable {
    let banners: [Banner]
    
    init(from decoder: any Decoder) throws {
        let singleContainer = try decoder.singleValueContainer()
        self.banners = try singleContainer.decode([Banner].self)
    }
}

extension BannerInfoDTO {
    
    func toDomain() -> [BannerInfo] {
        return self.banners.map { BannerInfo(urlString: $0.imagePresignedUrl) }
    }
}

struct Banner: Codable {
    let imagePresignedUrl: String
    let headText: String
    let subText: String
}
