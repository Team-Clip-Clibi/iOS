//
//  InitialMatchingSelectDietaryViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct InitialMatchingSelectDietaryViewBuilder: OTViewBuildable {
    
    typealias Store = InitialMatchingStore
    typealias Content = InitialMatchingSelectDietaryView
    
    var matchedPath: OTPath = .home(.initial(.dietary))
    
    func build(store: Binding<InitialMatchingStore>) -> InitialMatchingSelectDietaryView {
        InitialMatchingSelectDietaryView(store: store)
    }
}
