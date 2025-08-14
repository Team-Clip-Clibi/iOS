//
//  InitialMatchingMainViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct InitialMatchingMainViewBuilder: OTViewBuildable {
    
    typealias Store = InitialMatchingStore
    typealias Content = InitialMatchingMainView
    
    var matchedPath: OTPath = .home(.initial(.main))
    
    func build(store: Binding<InitialMatchingStore>) -> InitialMatchingMainView {
        InitialMatchingMainView(store: store)
    }
}
