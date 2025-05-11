//
//  NoticeDTO.swift
//  OneThing
//
//  Created by 오현식 on 5/9/25.
//

import Foundation

struct NoticeDTO: Codable {
    let noticeInfos: [NoticeInfo]
    
    init(from decoder: any Decoder) throws {
        let singleContainer = try decoder.singleValueContainer()
        self.noticeInfos = try singleContainer.decode([NoticeInfo].self)
    }
}
