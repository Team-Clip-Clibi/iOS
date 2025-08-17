//
//  OnethingMatchingPaymentViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct OnethingMatchingPaymentViewBuilder: OTViewBuildable {
    
    typealias Store = OnethingMatchingStore
    typealias Content = OnethingMatchingPaymentView
    
    var matchedPath: OTPath = .home(.onething(.payment))
    
    func build(store: Binding<OnethingMatchingStore>) -> OnethingMatchingPaymentView {
        OnethingMatchingPaymentView(store: store)
    }
}
