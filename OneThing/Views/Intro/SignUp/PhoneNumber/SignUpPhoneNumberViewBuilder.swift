//
//  SignUpPhoneNumberViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/7/25.
//

import SwiftUI

struct SignUpPhoneNumberViewBuilder: OTViewBuildable {
    
    typealias Store = SignUpStore
    typealias Content = SignUpPhoneNumberView
    
    var matchedPath: OTPath = .auth(.signUpPhoneNumber)
    
    func build(store: Binding<SignUpStore>) -> SignUpPhoneNumberView {
        SignUpPhoneNumberView(store: store)
    }
}
