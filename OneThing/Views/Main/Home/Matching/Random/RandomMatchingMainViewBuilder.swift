//
//  RandomMatchingMainViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct RandomMatchingMainViewBuilder: OTViewBuildable {
    
    typealias Store = RandomMatchingStore
    typealias Content = RandomMatchingMainView
    
    var matchedPath: OTPath = .home(.random(.main))
    
    func build(store: Binding<RandomMatchingStore>) -> RandomMatchingMainView {
        RandomMatchingMainView(store: store)
    }
}
