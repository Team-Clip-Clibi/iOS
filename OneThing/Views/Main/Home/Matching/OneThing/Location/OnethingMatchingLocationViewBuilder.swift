//
//  OnethingMatchingLocationViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct OnethingMatchingLocationViewBuilder: OTViewBuildable {
    
    typealias Store = OnethingMatchingStore
    typealias Content = OnethingMatchingLocationView
    
    var matchedPath: OTPath = .home(.onething(.location))
    
    func build(store: Binding<OnethingMatchingStore>) -> OnethingMatchingLocationView {
        OnethingMatchingLocationView(store: store)
    }
}
