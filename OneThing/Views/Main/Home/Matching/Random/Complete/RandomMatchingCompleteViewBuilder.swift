//
//  RandomMatchingCompleteViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct RandomMatchingCompleteViewBuilder: OTViewBuildable {
    
    typealias Store = RandomMatchingStore
    typealias Content = RandomMatchingCompleteView
    
    var matchedPath: OTPath = .home(.random(.complete))
    
    func build(store: Binding<RandomMatchingStore>) -> RandomMatchingCompleteView {
        RandomMatchingCompleteView(store: store)
    }
}
