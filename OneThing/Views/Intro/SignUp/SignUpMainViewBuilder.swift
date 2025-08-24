//
//  SignUpMainViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/7/25.
//

import SwiftUI

struct SignUpMainViewBuilder: OTViewBuildable {
    
    typealias Store = SignUpStore
    typealias Content = SignUpMainView
    
    var matchedPath: OTPath = .auth(.main)
    
    func build(store: Binding<SignUpStore>) -> SignUpMainView {
        SignUpMainView(store: store)
    }
}
