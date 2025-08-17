//
//  OnethingMatchingCompleteViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct OnethingMatchingCompleteViewBuilder: OTViewBuildable {
    
    typealias Store = OnethingMatchingStore
    typealias Content = OnethingMatchingCompleteView
    
    var matchedPath: OTPath = .home(.onething(.paySuccess))
    
    func build(store: Binding<OnethingMatchingStore>) -> OnethingMatchingCompleteView {
        OnethingMatchingCompleteView(store: store)
    }
}
