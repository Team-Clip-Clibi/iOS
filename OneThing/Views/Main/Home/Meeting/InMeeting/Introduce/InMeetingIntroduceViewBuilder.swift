//
//  InMeetingIntroduceViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct InMeetingIntroduceViewBuilder: OTViewBuildable {
    
    typealias Store = InMeetingStore
    typealias Content = InMeetingIntroduceView
    
    var matchedPath: OTPath = .home(.inMeeting(.introduce))
    
    func build(store: Binding<InMeetingStore>) -> InMeetingIntroduceView {
        InMeetingIntroduceView(store: store)
    }
}
