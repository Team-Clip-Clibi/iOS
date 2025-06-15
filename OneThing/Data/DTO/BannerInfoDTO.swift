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
    let imagePresignedUrl: String?
    let headText: String?
    let subText: String?
}

extension Array where Element == BannerInfoDTO {
    func toDomain() -> [HomeBannerInfo] {
        return self.map { HomeBannerInfo(urlString: $0.imagePresignedUrl ?? "") }
    }
    
    func toDomain() -> [LoginBannerInfo] {
        return self.map { LoginBannerInfo(imagePresignedUrl: $0.imagePresignedUrl ?? "",
                                          headText: $0.headText ?? "",
                                          subText: $0.subText ?? "")}
    }
}
