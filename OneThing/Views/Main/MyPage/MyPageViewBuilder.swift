//
//  MyPageViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/9/25.
//

import SwiftUI

struct MyPageViewBuilder: OTViewBuildable {
    
    typealias Store = MyPageEditStore
    typealias Content = MyPageView
    
    var matchedPath: OTPath = .myPage(.main)
    
    func build(store: Binding<MyPageEditStore>) -> MyPageView {
        MyPageView(store: store)
    }
}
