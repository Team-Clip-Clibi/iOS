//
//  MyPageNotificationViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/9/25.
//

import SwiftUI

struct MyPageNotificationViewBuilder: OTViewBuildable {
    
    typealias Store = MyPageNotificationStore
    typealias Content = MyPageNotificationView
    
    var matchedPath: OTPath = .myPage(.notification)
    
    func build(store: Binding<MyPageNotificationStore>) -> MyPageNotificationView {
        MyPageNotificationView(store: store)
    }
}
