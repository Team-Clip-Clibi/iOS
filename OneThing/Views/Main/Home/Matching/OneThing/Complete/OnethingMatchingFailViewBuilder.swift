//
//  OnethingMatchingFailViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct OnethingMatchingFailViewBuilder: OTViewBuildable {
    
    typealias Store = OnethingMatchingStore
    typealias Content = OnethingMatchingFailView
    
    var matchedPath: OTPath = .home(.onething(.paySuccess))
    
    func build(store: Binding<OnethingMatchingStore>) -> OnethingMatchingFailView {
        OnethingMatchingFailView(store: store)
    }
}
