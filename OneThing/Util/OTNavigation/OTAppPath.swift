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
}


enum OTMyMeetingPath: Hashable, Equatable {
    var id: String { UUID().uuidString }
    
    case myPage
    
    case editProfile
    
    case notification
    
    case privacyAndPolicy
    case reportMatching
}

enum OTMyPagePath: Hashable, Equatable {
    var id: String { UUID().uuidString }
    
    case editProfile
    
    case editNickName
    case editJob
    case editRelationship
    case editDiet
    case editLanguage
    
    case report
    case reportMatching
    case reportReason
}
