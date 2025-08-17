//
//  OnethingMatchingMainViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct OnethingMatchingMainViewBuilder: OTViewBuildable {
    
    typealias Store = OnethingMatchingStore
    typealias Content = OnethingMatchingMainView
    
    var matchedPath: OTPath = .home(.onething(.main))
    
    func build(store: Binding<OnethingMatchingStore>) -> OnethingMatchingMainView {
        OnethingMatchingMainView(store: store)
    }
}
