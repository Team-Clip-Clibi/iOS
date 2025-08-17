//
//  RandomMatchingTMIViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct RandomMatchingTMIViewBuilder: OTViewBuildable {
    
    typealias Store = RandomMatchingStore
    typealias Content = RandomMatchingTMIView
    
    var matchedPath: OTPath = .home(.random(.tmi))
    
    func build(store: Binding<RandomMatchingStore>) -> RandomMatchingTMIView {
        RandomMatchingTMIView(store: store)
    }
}
