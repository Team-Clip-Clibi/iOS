//
//  InMeetingCoordinator.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

@Observable
final class InMeetingCoordinator: OTBaseCoordinator {

    private var inMeetingStore: InMeetingStore
    private var inMeetingStoreForBinding: Binding<InMeetingStore> {
        Binding(
            get: { self.inMeetingStore },
            set: { self.inMeetingStore = $0 }
        )
    }
    
    var dependencies: AppDIContainer
    
    var matchingId: String
    var matchingType: MatchingType
    
    init(
        dependencies: AppDIContainer,
        with matchingId: String,
        type matchingType: MatchingType
    ) {
        self.dependencies = dependencies
        
        let inMeetingStore = dependencies.setupInMeetingContatiner(
            with: matchingId,
            type: matchingType
        ).resolve(InMeetingStore.self)
        self.inMeetingStore = inMeetingStore
        
        self.matchingId = matchingId
        self.matchingType = matchingType
        
        super.init(rootViewBuilder: InMeetingMainViewBuilder())
    }
    
    @ViewBuilder
    func destinationView(to path: OTPath) -> some View {
        switch path {
        case .home(.inMeeting(.selectHost)):
            InMeetingSelectHostViewBuilder().build(store: self.inMeetingStoreForBinding)
        case .home(.inMeeting(.introduce)):
            InMeetingIntroduceViewBuilder().build(store: self.inMeetingStoreForBinding)
        case .home(.inMeeting(.tmi)):
            InMeetingTMIViewBuilder().build(store: self.inMeetingStoreForBinding)
        case .home(.inMeeting(.onething)):
            InMeetingOnethingViewBuilder().build(store: self.inMeetingStoreForBinding)
        case .home(.inMeeting(.content)):
            InMeetingContentViewBuilder().build(store: self.inMeetingStoreForBinding)
        case .home(.inMeeting(.complete)):
            InMeetingCompleteViewbuilder().build(store: self.inMeetingStoreForBinding)
        default:
            EmptyView()
        }
    }
}
