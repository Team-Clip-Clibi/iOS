//
//  HomeViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/2/25.
//

import SwiftUI

struct HomeViewBuilder: OTViewBuildable {
    
    typealias Store = HomeStore
    typealias Content = HomeView
    
    var matchedPath: OTPath = .home(.main)
    
    func build(store: Binding<HomeStore>) -> HomeView {
        HomeView(store: store)
    }
}
