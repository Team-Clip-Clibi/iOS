//
//  OnethingMatchingTMIViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct OnethingMatchingTMIViewBuilder: OTViewBuildable {
    
    typealias Store = OnethingMatchingStore
    typealias Content = OnethingMatchingTMIView
    
    var matchedPath: OTPath = .home(.onething(.tmi))
    
    func build(store: Binding<OnethingMatchingStore>) -> OnethingMatchingTMIView {
        OnethingMatchingTMIView(store: store)
    }
}
