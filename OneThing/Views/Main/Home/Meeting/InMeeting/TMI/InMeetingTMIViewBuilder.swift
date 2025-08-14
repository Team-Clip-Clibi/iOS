//
//  InMeetingTMIViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct InMeetingTMIViewBuilder: OTViewBuildable {
    
    typealias Store = InMeetingStore
    typealias Content = InMeetingTMIView
    
    var matchedPath: OTPath = .home(.inMeeting(.tmi))
    
    func build(store: Binding<InMeetingStore>) -> InMeetingTMIView {
        InMeetingTMIView(store: store)
    }
}
