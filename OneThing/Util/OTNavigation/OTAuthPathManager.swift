//
//  OTAuthPathManager.swift
//  OneThing
//
//  Created by 윤동주 on 4/4/25.
//

import Foundation

@Observable
class OTAuthPathManager {
    var paths: [OTAuthPath] = []
    
    var currentTab: OTAppTab = .home
    
    func push(path: OTAuthPath) {
        self.paths.append(path)
    }
    
    func pop() {
        self.paths.removeLast()
    }
    
    func popToRoot() {
        self.paths.removeAll()
    }
    
}
