//
//  OnethingMatchingCategoryViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct OnethingMatchingCategoryViewBuilder: OTViewBuildable {
    
    typealias Store = OnethingMatchingStore
    typealias Content = OnethingMatchingCategoryView
    
    var matchedPath: OTPath = .home(.onething(.category))
    
    func build(store: Binding<OnethingMatchingStore>) -> OnethingMatchingCategoryView {
        OnethingMatchingCategoryView(store: store)
    }
}
