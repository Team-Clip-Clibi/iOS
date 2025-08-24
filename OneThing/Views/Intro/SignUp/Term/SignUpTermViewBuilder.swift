//
//  SignUpTermViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/7/25.
//

import SwiftUI

struct SignUpTermViewBuilder: OTViewBuildable {
    
    typealias Store = SignUpStore
    typealias Content = SignUpTermView
    
    var matchedPath: OTPath = .auth(.signUpTerm)
    
    func build(store: Binding<SignUpStore>) -> SignUpTermView {
        SignUpTermView(store: store)
    }
}
