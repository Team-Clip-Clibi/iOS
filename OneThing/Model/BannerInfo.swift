//
//  BannerInfo.swift
//  OneThing
//
//  Created by 오현식 on 5/10/25.
//

import Foundation

struct BannerInfo: Equatable, Identifiable {
    var id: String = UUID().uuidString
    let urlString: String
}
