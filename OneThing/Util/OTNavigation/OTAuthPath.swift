//
//  OTAuthPath.swift
//  OneThing
//
//  Created by 윤동주 on 4/4/25.
//

import Foundation

enum OTAuthPath: Hashable, Equatable {
    var id: String { UUID().uuidString }
    
    case signUpNickname
    case signUpName
    case signUpPhoneNumber
    case signUpTerm
    case signUpMoreInformation
}
