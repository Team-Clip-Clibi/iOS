//
//  OTPath.swift
//  OneThing
//
//  Created by 오현식 on 7/15/25.
//

import Foundation

enum OTPath: Identifiable, Hashable {
    
    var id: String { String(describing: self) }
    
    case auth(OTAuthPath)
    case home(OTHomePath)
    case myMeeting(OTMyMeetingPath)
    case myPage(OTMyPagePath)
}

extension OTPath {
    
    enum OTAuthPath: Identifiable, Hashable {
        
        var id: String { String(describing: self) }
        
        case signUpNickname
        case signUpName
        case signUpPhoneNumber
        case signUpTerm
        case signUpMoreInformation
    }
}

extension OTPath {
    
    enum OTHomePath: Identifiable, Hashable {
        
        var id: String { String(describing: self) }
        
        case notification
        
        case inMeeting(InMeeting)
        
        case initial(InitialMatching)
        case onething(OnethingMatching)
        case random(RandomMatching)
        
        enum InitialMatching: Equatable {
            case main
            case job
            case dietary
            case language
        }
        
        enum OnethingMatching: Equatable {
            case main
            case category
            case topic
            case location
            case price
            case tmi
            case date
            case payment
            case complete
        }
        
        enum RandomMatching: Equatable {
            case main
            case location
            case topic
            case tmi
            case payment
            case complete
        }
        
        enum InMeeting: Equatable {
            
            case main
            case selectHost
            case introduce
            case tmi
            case oneThing
            case content
            case complete
        }
    }


    enum OTMyMeetingPath: Identifiable, Hashable {
        
        var id: String { String(describing: self) }
    }

    enum OTMyPagePath: Identifiable, Hashable {
        
        var id: String { String(describing: self) }
        
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
}
