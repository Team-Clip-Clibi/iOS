//
//  OTAppPath.swift
//  OneThing
//
//  Created by 윤동주 on 4/13/25.
//

import Foundation

enum OTHomePath: Hashable, Equatable {
    var id: String { UUID().uuidString }
    
    case notification
    
    case random(RandomMatching)
    
    enum RandomMatching: Equatable {
        case main
        case location
        case topic
        case tmi
        case payment
        case complete
    }
}


enum OTMyMeetingPath: Hashable, Equatable {
    var id: String { UUID().uuidString }
    
}

enum OTMyPagePath: Hashable, Equatable {
    var id: String { UUID().uuidString }
    
    case editProfile
    
    case editNickName
    case editJob
    case editRelationship
    case editDiet
    case editLanguage
    
    case notification
    
    case report
    case reportMatching
    case reportReason
    
    case term
}
