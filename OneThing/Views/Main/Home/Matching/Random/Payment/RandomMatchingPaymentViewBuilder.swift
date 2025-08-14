//
//  RandomMatchingPaymentViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct RandomMatchingPaymentViewBuilder: OTViewBuildable {
    
    typealias Store = RandomMatchingStore
    typealias Content = RandomMatchingPaymentView
    
    var matchedPath: OTPath = .home(.random(.payment))
    
    func build(store: Binding<RandomMatchingStore>) -> RandomMatchingPaymentView {
        RandomMatchingPaymentView(store: store)
    }
}
