//
//  MyPageEditNicknameViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/9/25.
//

import SwiftUI

struct MyPageEditNicknameViewBuilder: OTViewBuildable {
    
    typealias Store = MyPageEditStore
    typealias Content = MyPageEditNicknameView
    
    var matchedPath: OTPath = .myPage(.editNickName)
    
    func build(store: Binding<MyPageEditStore>) -> MyPageEditNicknameView {
        MyPageEditNicknameView(store: store)
    }
}
