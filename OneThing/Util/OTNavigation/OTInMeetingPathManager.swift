//
//  OTInMeetingPathManager.swift
//  OneThing
//
//  Created by 오현식 on 6/5/25.
//

import Foundation

@Observable
class OTInMeetingPathManager {
    var paths: [OTInMeetingPath] = []
    
    var currentTab: OTAppTab = .home
    
    func push(path: OTInMeetingPath) {
        self.paths.append(path)
    }
    
    func pop() {
        self.paths.removeLast()
    }
    
    func popToRoot() {
        self.paths.removeAll()
    }
    
}
