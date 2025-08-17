//
//  InMeetingSelectHostViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct InMeetingSelectHostViewBuilder: OTViewBuildable {
    
    typealias Store = InMeetingStore
    typealias Content = InMeetingSelectHostView
    
    var matchedPath: OTPath = .home(.inMeeting(.selectHost))
    
    func build(store: Binding<InMeetingStore>) -> InMeetingSelectHostView {
        InMeetingSelectHostView(store: store)
    }
}
