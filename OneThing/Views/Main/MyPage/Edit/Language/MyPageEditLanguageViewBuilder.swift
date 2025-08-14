//
//  MyPageEditLanguageViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/9/25.
//

import SwiftUI

struct MyPageEditLanguageViewBuilder: OTViewBuildable {
    
    typealias Store = MyPageEditStore
    typealias Content = MyPageEditLanguageView
    
    var matchedPath: OTPath = .myPage(.editLanguage)
    
    func build(store: Binding<MyPageEditStore>) -> MyPageEditLanguageView {
        MyPageEditLanguageView(store: store)
    }
}
