//
//  MeetingReviewViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/10/25.
//

import SwiftUI

struct MeetingReviewViewBuilder: OTViewBuildable {
    
    typealias Store = MeetingReviewStore
    typealias Content = MeetingReviewView
    
    var matchedPath: OTPath = .home(.meetingReview)
    
    func build(store: Binding<MeetingReviewStore>) -> MeetingReviewView {
        MeetingReviewView(store: store)
    }
}
