//
//  InitialMatchingSelectLanguageViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct InitialMatchingSelectLanguageViewBuilder: OTViewBuildable {
    
    typealias Store = InitialMatchingStore
    typealias Content = InitialMatchingSelectLanguageView
    
    var matchedPath: OTPath = .home(.initial(.language))
    
    func build(store: Binding<InitialMatchingStore>) -> InitialMatchingSelectLanguageView {
        InitialMatchingSelectLanguageView(store: store)
    }
}
