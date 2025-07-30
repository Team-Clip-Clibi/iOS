//
//  ParticipantDTO.swift
//  OneThing
//
//  Created by 윤동주 on 7/27/25.
//

import Foundation

struct ParticipantDTO {
    let participantInfos: [ParticipantInfo]
}

extension ParticipantDTO: Codable {
    
    init(from decoder: any Decoder) throws {
        let singleContainer = try decoder.singleValueContainer()
        self.participantInfos = try singleContainer.decode([ParticipantInfo].self)
    }
}
