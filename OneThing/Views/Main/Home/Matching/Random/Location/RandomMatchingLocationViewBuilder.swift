//
//  RandomMatchingLocationViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct RandomMatchingLocationViewBuilder: OTViewBuildable {
    
    typealias Store = RandomMatchingStore
    typealias Content = RandomMatchingLocationView
    
    var matchedPath: OTPath = .home(.random(.location))
    
    func build(store: Binding<RandomMatchingStore>) -> RandomMatchingLocationView {
        RandomMatchingLocationView(store: store)
    }
}
