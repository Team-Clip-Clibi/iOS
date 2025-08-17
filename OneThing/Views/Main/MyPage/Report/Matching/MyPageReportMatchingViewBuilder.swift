//
//  MyPageReportMatchingViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/9/25.
//

import SwiftUI

struct MyPageReportMatchingViewBuilder: OTViewBuildable {
    
    typealias Store = MyPageReportStore
    typealias Content = MyPageReportMatchingView
    
    var matchedPath: OTPath = .myPage(.reportMatching)
    
    func build(store: Binding<MyPageReportStore>) -> MyPageReportMatchingView {
        MyPageReportMatchingView(store: store)
    }
}
