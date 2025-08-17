//
//  MainTabBarViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/7/25.
//

import SwiftUI

struct MainTabBarViewBuilder: OTViewBuildable {
    
    typealias Store = EmptyStore
    typealias Content = MainTabBarView
    
    var matchedPath: OTPath = .tabbar
    
    func build() -> MainTabBarView {
        MainTabBarView()
    }
}
