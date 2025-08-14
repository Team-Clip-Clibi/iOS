//
//  MyPageReportMainViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/9/25.
//

import SwiftUI

struct MyPageReportMainViewBuilder: OTViewBuildable {
    
    typealias Store = MyPageReportStore
    typealias Content = MyPageReportMainView
    
    var matchedPath: OTPath = .myPage(.report)
    
    func build(store: Binding<MyPageReportStore>) -> MyPageReportMainView {
        MyPageReportMainView(store: store)
    }
}
