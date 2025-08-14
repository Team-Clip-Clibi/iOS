//
//  InitialMatchingSelectJobViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct InitialMatchingSelectJobViewBuilder: OTViewBuildable {
    
    typealias Store = InitialMatchingStore
    typealias Content = InitialMatchingSelectJobView
    
    var matchedPath: OTPath = .home(.initial(.job))
    
    func build(store: Binding<InitialMatchingStore>) -> InitialMatchingSelectJobView {
        InitialMatchingSelectJobView(store: store)
    }
}
