//
//  MyPageEditJobViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/9/25.
//

import SwiftUI

struct MyPageEditJobViewBuilder: OTViewBuildable {
    
    typealias Store = MyPageEditStore
    typealias Content = MyPageEditJobView
    
    var matchedPath: OTPath = .myPage(.editJob)
    
    func build(store: Binding<MyPageEditStore>) -> MyPageEditJobView {
        MyPageEditJobView(store: store)
    }
}
