//
//  NotificationViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct NotificationViewBuilder: OTViewBuildable {
    
    typealias Store = NotificationStore
    typealias Content = NotificationView
    
    var matchedPath: OTPath = .home(.notification)
    
    func build(store: Binding<NotificationStore>) -> NotificationView {
        NotificationView(store: store)
    }
}
