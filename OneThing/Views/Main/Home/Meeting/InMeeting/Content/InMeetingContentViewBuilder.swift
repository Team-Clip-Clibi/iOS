//
//  InMeetingContentViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct InMeetingContentViewBuilder: OTViewBuildable {
    
    typealias Store = InMeetingStore
    typealias Content = InMeetingContentView
    
    var matchedPath: OTPath = .home(.inMeeting(.tmi))
    
    func build(store: Binding<InMeetingStore>) -> InMeetingContentView {
        InMeetingContentView(store: store)
    }
}
