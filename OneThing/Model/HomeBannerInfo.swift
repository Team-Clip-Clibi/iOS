//
//  BannerInfo.swift
//  OneThing
//
//  Created by 오현식 on 5/10/25.
//

import Foundation

struct HomeBannerInfo: Equatable, Identifiable {
    var id: String = UUID().uuidString
    let urlString: String
}

struct LoginBannerInfo: Equatable {
    let imagePresignedUrl: String
    let text: String
}
