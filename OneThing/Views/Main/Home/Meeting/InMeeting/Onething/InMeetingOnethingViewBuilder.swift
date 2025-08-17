//
//  InMeetingOnethingViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct InMeetingOnethingViewBuilder: OTViewBuildable {
    
    typealias Store = InMeetingStore
    typealias Content = InMeetingOnethingView
    
    var matchedPath: OTPath = .home(.inMeeting(.onething))
    
    func build(store: Binding<InMeetingStore>) -> InMeetingOnethingView {
        InMeetingOnethingView(store: store)
    }
}
