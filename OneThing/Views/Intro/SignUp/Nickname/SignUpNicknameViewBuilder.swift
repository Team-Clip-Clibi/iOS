//
//  SignUpNicknameViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/7/25.
//

import SwiftUI

struct SignUpNicknameViewBuilder: OTViewBuildable {
    
    typealias Store = SignUpStore
    typealias Content = SignUpNicknameView
    
    var matchedPath: OTPath = .auth(.signUpNickname)
    
    func build(store: Binding<SignUpStore>) -> SignUpNicknameView {
        SignUpNicknameView(store: store)
    }
}
