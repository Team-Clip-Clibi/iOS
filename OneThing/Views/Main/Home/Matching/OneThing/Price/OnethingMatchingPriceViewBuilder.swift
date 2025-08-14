//
//  OnethingMatchingPriceViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct OnethingMatchingPriceViewBuilder: OTViewBuildable {
    
    typealias Store = OnethingMatchingStore
    typealias Content = OnethingMatchingPriceView
    
    var matchedPath: OTPath = .home(.onething(.price))
    
    func build(store: Binding<OnethingMatchingStore>) -> OnethingMatchingPriceView {
        OnethingMatchingPriceView(store: store)
    }
}
