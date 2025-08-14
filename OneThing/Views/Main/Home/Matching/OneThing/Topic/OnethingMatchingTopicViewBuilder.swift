//
//  OnethingMatchingTopicViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct OnethingMatchingTopicViewBuilder: OTViewBuildable {
    
    typealias Store = OnethingMatchingStore
    typealias Content = OnethingMatchingTopicView
    
    var matchedPath: OTPath = .home(.onething(.topic))
    
    func build(store: Binding<OnethingMatchingStore>) -> OnethingMatchingTopicView {
        OnethingMatchingTopicView(store: store)
    }
}
