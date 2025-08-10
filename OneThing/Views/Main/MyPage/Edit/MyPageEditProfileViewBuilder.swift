//
//  MyPageEditProfileViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/9/25.
//

import SwiftUI

struct MyPageEditProfileViewBuilder: OTViewBuildable {
    
    typealias Store = MyPageEditStore
    typealias Content = MyPageEditProfileView
    
    var matchedPath: OTPath = .myPage(.editProfile)
    
    func build(store: Binding<MyPageEditStore>) -> MyPageEditProfileView {
        MyPageEditProfileView(store: store)
    }
}
