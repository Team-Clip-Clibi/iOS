//
//  OTAppPathManager.swift
//  OneThing
//
//  Created by 윤동주 on 4/13/25.
//

import SwiftUI

@Observable
class OTAppPathManager {
    
    var homePaths: [OTHomePath] = []
    
    var myMeetingPaths: [OTMyMeetingPath] = []
    
    var myPagePaths: [OTMyPagePath] = []
    
    var currentTab: OTAppTab = .home
    
    var isTabBarHidden: Bool = false
    
    var nextPathWhenInitialFinished: OTHomePath.MatchingType?
    
    // MARK: - Functions

    func push(path: OTHomePath) {
        self.homePaths.append(path)
    }
    
    func pushWhenInitialFinished() {
        self.homePaths.removeAll { path in
            switch path {
            case .initial(_): return true
            default: return false
            }
        }
        
        guard let nextPath = self.nextPathWhenInitialFinished else { return }
        switch nextPath {
        case .oneThing: self.push(path: .oneThing(.main))
        case .random: self.push(path: .random(.main))
        }
    }
    
    func push(path: OTMyMeetingPath) {
        self.myMeetingPaths.append(path)
    }
    
    func push(path: OTMyPagePath) {
        self.myPagePaths.append(path)
    }
    
    func pop() {
        switch currentTab {
        case .home:
            self.homePaths.removeLast()
        case .myMeeting:
            self.myMeetingPaths.removeLast()
        case .my:
            self.myPagePaths.removeLast()
        }
    }
    
    func popToRoot() {
        switch currentTab {
        case .home:
            self.homePaths.removeAll()
        case .myMeeting:
            self.myMeetingPaths.removeAll()
        case .my:
            self.myPagePaths.removeAll()
        }
    }
    
    func withTabBarHiddenThenNavigate(_ navigate: @escaping () -> Void) {
        withAnimation(.easeInOut(duration: 0.2)) {
            isTabBarHidden = true
        }
        
        Task {
            try await Task.sleep(nanoseconds: 200_000_000)
            navigate()
        }
    }
}

enum OTAppTab: Equatable {
    case home
    case myMeeting
    case my
}
