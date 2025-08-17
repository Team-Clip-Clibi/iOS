//
//  InMeetingCoordinator.swift
//  OneThing
//
//  Created by 오현식 on 8/15/25.
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
    
    var inMeetingInfo: (matchingId: String, matchingType: MatchingType) = ("", .onething) {
        didSet {
            self.inMeetingStore = self.dependencies.setupInMeetingContatiner(
                with: self.inMeetingInfo.matchingId,
                type: self.inMeetingInfo.matchingType
            ).resolve(InMeetingStore.self)
        }
    }
    
    init(dependencies: AppDIContainer) {
        self.dependencies = dependencies
        
        let inMeetingStore = dependencies.setupInMeetingContatiner(
            with: "",
            type: .onething
        ).resolve(InMeetingStore.self)
        self.inMeetingStore = inMeetingStore
        
        super.init(rootViewBuilder: InMeetingMainViewBuilder())
    }
    
    func start() -> InMeetingMainView {
        return (self.rootViewBuilder as! InMeetingMainViewBuilder).build(store: self.inMeetingStoreForBinding)
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

private struct InMeetingCoordinatorKey: EnvironmentKey {
    // static var defaultValue: AppCoordinator {
    //     fatalError("FatalError: AppCoordinator not set in environment")
    // }
    static var defaultValue: InMeetingCoordinator = InMeetingCoordinator(dependencies: AppDIContainer())
}

extension EnvironmentValues {
    var inMeetingCoordinator: InMeetingCoordinator {
        get { self[InMeetingCoordinatorKey.self] }
        set { self[InMeetingCoordinatorKey.self] = newValue }
    }
}
