//
//  SignUpMoreInformationViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/7/25.
//

import SwiftUI

struct SignUpMoreInformationViewBuilder: OTViewBuildable {
    
    typealias Store = SignUpStore
    typealias Content = SignUpMoreInformationView
    
    var matchedPath: OTPath = .auth(.signUpMoreInformation)
    
    func build(store: Binding<SignUpStore>) -> SignUpMoreInformationView {
        SignUpMoreInformationView(store: store)
    }
}
