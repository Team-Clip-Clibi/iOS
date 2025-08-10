//
//  OnethingMatchingDateViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct OnethingMatchingDateViewBuilder: OTViewBuildable {
    
    typealias Store = OnethingMatchingStore
    typealias Content = OnethingMatchingDateView
    
    var matchedPath: OTPath = .home(.onething(.date))
    
    func build(store: Binding<OnethingMatchingStore>) -> OnethingMatchingDateView {
        OnethingMatchingDateView(store: store)
    }
}
