//
//  OTInMeetingPath.swift
//  OneThing
//
//  Created by 오현식 on 6/5/25.
//

import Foundation

enum OTInMeetingPath: Hashable, Equatable {
    var id: String { UUID().uuidString }
    
    case main
    case selectHost
    case introduce
    case tmi
    case onething
    case content
    case complete
}
