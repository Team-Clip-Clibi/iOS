//
//  InMeetingCompleteViewbuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct InMeetingCompleteViewbuilder: OTViewBuildable {
    
    typealias Store = InMeetingStore
    typealias Content = InMeetingCompleteView
    
    var matchedPath: OTPath = .home(.inMeeting(.tmi))
    
    func build(store: Binding<InMeetingStore>) -> InMeetingCompleteView {
        InMeetingCompleteView(store: store)
    }
}
