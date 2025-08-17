//
//  InMeetingMainViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct InMeetingMainViewBuilder: OTViewBuildable {
    
    typealias Store = InMeetingStore
    typealias Content = InMeetingMainView
    
    var matchedPath: OTPath = .home(.inMeeting(.main))
    
    func build(store: Binding<InMeetingStore>) -> InMeetingMainView {
        InMeetingMainView(store: store)
    }
}
