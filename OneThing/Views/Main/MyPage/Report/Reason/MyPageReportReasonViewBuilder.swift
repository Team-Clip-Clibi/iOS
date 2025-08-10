//
//  MyPageReportReasonViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/9/25.
//

import SwiftUI

struct MyPageReportReasonViewBuilder: OTViewBuildable {
    
    typealias Store = MyPageReportStore
    typealias Content = MyPageReportReasonView
    
    var matchedPath: OTPath = .myPage(.reportReason)
    
    func build(store: Binding<MyPageReportStore>) -> MyPageReportReasonView {
        MyPageReportReasonView(store: store)
    }
}
