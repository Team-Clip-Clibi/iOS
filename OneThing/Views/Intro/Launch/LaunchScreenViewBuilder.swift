//
//  LaunchScreenViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/2/25.
//

import SwiftUI

struct LaunchScreenViewBuilder: OTViewBuildable {
    
    typealias Store = LaunchScreenStore
    typealias Content = LaunchScreenView
    
    var matchedPath: OTPath = .launch
    
    func build(store: Binding<LaunchScreenStore>) -> LaunchScreenView {
        LaunchScreenView(store: store)
    }
}
