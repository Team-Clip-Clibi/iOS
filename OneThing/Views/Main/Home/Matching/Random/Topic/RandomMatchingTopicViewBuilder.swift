//
//  RandomMatchingTopicViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct RandomMatchingTopicViewBuilder: OTViewBuildable {
    
    typealias Store = RandomMatchingStore
    typealias Content = RandomMatchingTopicView
    
    var matchedPath: OTPath = .home(.random(.topic))
    
    func build(store: Binding<RandomMatchingStore>) -> RandomMatchingTopicView {
        RandomMatchingTopicView(store: store)
    }
}
