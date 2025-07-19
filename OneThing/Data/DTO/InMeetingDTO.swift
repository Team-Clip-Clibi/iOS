//
//  InMeetingDTO.swift
//  OneThing
//
//  Created by 오현식 on 7/18/25.
//

import Foundation

struct InMeetingDTO: Decodable {
    let inMeetingInfo: InMeetingInfo
}

extension InMeetingDTO {
    
    init(from decoder: any Decoder) throws {
        let singleContainer = try decoder.singleValueContainer()
        self.inMeetingInfo = try singleContainer.decode(InMeetingInfo.self)
    }
}
