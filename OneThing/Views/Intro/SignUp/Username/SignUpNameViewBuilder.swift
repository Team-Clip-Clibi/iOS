//
//  SignUpNameViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/7/25.
//

import SwiftUI

struct SignUpNameViewBuilder: OTViewBuildable {
    
    typealias Store = SignUpStore
    typealias Content = SignUpNameView
    
    var matchedPath: OTPath = .auth(.signUpName)
    
    func build(store: Binding<SignUpStore>) -> SignUpNameView {
        SignUpNameView(store: store)
    }
}
