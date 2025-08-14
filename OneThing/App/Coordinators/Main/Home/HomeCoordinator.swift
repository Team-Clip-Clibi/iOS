//
//  HomeCoordinator.swift
//  OneThing
//
//  Created by 오현식 on 8/7/25.
//

import SwiftUI

@Observable
final class HomeCoordinator: OTBaseCoordinator {

    private var homeStore: HomeStore
    private var homeStoreForBinding: Binding<HomeStore> {
        Binding(
            get: { self.homeStore },
            set: { self.homeStore = $0 }
        )
    }
    
    private var notificationStore: NotificationStore
    private var notificationStoreForBinding: Binding<NotificationStore> {
        Binding(
            get: { self.notificationStore },
            set: { self.notificationStore = $0 }
        )
    }
    
    private var initialMatchingStore: InitialMatchingStore
    private var initialMatchingStoreForBinding: Binding<InitialMatchingStore> {
        Binding(
            get: { self.initialMatchingStore },
            set: { self.initialMatchingStore = $0 }
        )
    }
    
    private var onethingMatchingStore: OnethingMatchingStore
    private var onethingMatchingStoreForBinding: Binding<OnethingMatchingStore> {
        Binding(
            get: { self.onethingMatchingStore },
            set: { self.onethingMatchingStore = $0 }
        )
    }
    
    private var randomMatchingStore: RandomMatchingStore
    private var randomMatchingStoreForBinding: Binding<RandomMatchingStore> {
        Binding(
            get: { self.randomMatchingStore },
            set: { self.randomMatchingStore = $0 }
        )
    }
    
    private var inMeetingStore: InMeetingStore
    private var inMeetingStoreForBinding: Binding<InMeetingStore> {
        Binding(
            get: { self.inMeetingStore },
            set: { self.inMeetingStore = $0 }
        )
    }
    
    private var meetingReviewStore: MeetingReviewStore
    private var meetingReviewStoreForBinding: Binding<MeetingReviewStore> {
        Binding(
            get: { self.meetingReviewStore },
            set: { self.meetingReviewStore = $0 }
        )
    }
    
    var dependencies: AppDIContainer
    
    var willPushedMatchingType: MatchingType
    
    var initialReviewInfo: MeetingReviewStore.InitialInfo = .init() {
        didSet {
            self.meetingReviewStore = self.dependencies.setupMeetingReviewContainer(
                self.initialReviewInfo.nicknames,
                with: self.initialReviewInfo.matchingId,
                type: self.initialReviewInfo.matchingtype
            ).resolve(MeetingReviewStore.self)
        }
    }
    var inMeetingInfo: (matchingId: String, matchingType: MatchingType) = ("", .onething) {
        didSet {
            self.inMeetingStore = self.dependencies.setupInMeetingContatiner(
                with: self.inMeetingInfo.matchingId,
                type: self.inMeetingInfo.matchingType
            ).resolve(InMeetingStore.self)
        }
    }
    
    init(
        dependencies: AppDIContainer,
        initialType willPushedMatchingType: MatchingType
    ) {
        self.dependencies = dependencies
        
        self.willPushedMatchingType = willPushedMatchingType
        
        let homeStore = dependencies.setupHomeCotainer().resolve(HomeStore.self)
        self.homeStore = homeStore
        
        let notificationStore = dependencies.setupNotificationContainer().resolve(NotificationStore.self)
        self.notificationStore = notificationStore
        
        let initialMatchingStore = dependencies.setupInitialMatchingContainer(
            with: willPushedMatchingType
        ).resolve(InitialMatchingStore.self)
        self.initialMatchingStore = initialMatchingStore
        
        let onethingMatchingStore = dependencies.setupOnethingMatchingContainer().resolve(OnethingMatchingStore.self)
        self.onethingMatchingStore = onethingMatchingStore
        
        let randomMatchingStore = dependencies.setupRandomMatchingContainer().resolve(RandomMatchingStore.self)
        self.randomMatchingStore = randomMatchingStore
        
        let inMeetingStore = dependencies.setupInMeetingContatiner(
            with: "",
            type: .onething
        ).resolve(InMeetingStore.self)
        self.inMeetingStore = inMeetingStore
        
        let meetingReviewStore = dependencies.setupMeetingReviewContainer(
            [],
            with: "",
            type: .onething
        ).resolve(MeetingReviewStore.self)
        self.meetingReviewStore = meetingReviewStore
        
        super.init(rootViewBuilder: HomeViewBuilder())
    }
    
    func start() -> HomeView {
        return (self.rootViewBuilder as! HomeViewBuilder).build(store: self.homeStoreForBinding)
    }
    
    func presentInMeeting() -> InMeetingMainView {
        return InMeetingMainViewBuilder().build(store: self.inMeetingStoreForBinding)
    }
    
    func presentMeetingReview() -> MeetingReviewView {
        return MeetingReviewViewBuilder().build(store: self.meetingReviewStoreForBinding)
    }
    
    @ViewBuilder
    func destinationView(to path: OTPath) -> some View {
         
        switch path {
        case .home(.notification):
            NotificationViewBuilder().build(store: self.notificationStoreForBinding)

        case .home(.initial(.main)):
            InitialMatchingMainViewBuilder().build(store: self.initialMatchingStoreForBinding)
        case .home(.initial(.job)):
            InitialMatchingSelectJobViewBuilder().build(store: self.initialMatchingStoreForBinding)
        case .home(.initial(.dietary)):
            InitialMatchingSelectDietaryViewBuilder().build(store: self.initialMatchingStoreForBinding)
        case .home(.initial(.language)):
            InitialMatchingSelectLanguageViewBuilder().build(store: self.initialMatchingStoreForBinding)

        case .home(.onething(.main)):
            OnethingMatchingMainViewBuilder().build(store: self.onethingMatchingStoreForBinding)
        case .home(.onething(.category)):
            OnethingMatchingCategoryViewBuilder().build(store: self.onethingMatchingStoreForBinding)
        case .home(.onething(.topic)):
            OnethingMatchingTopicViewBuilder().build(store: self.onethingMatchingStoreForBinding)
        case .home(.onething(.location)):
            OnethingMatchingLocationViewBuilder().build(store: self.onethingMatchingStoreForBinding)
        case .home(.onething(.price)):
            OnethingMatchingPriceViewBuilder().build(store: self.onethingMatchingStoreForBinding)
        case .home(.onething(.tmi)):
            OnethingMatchingTMIViewBuilder().build(store: self.onethingMatchingStoreForBinding)
        case .home(.onething(.date)):
            OnethingMatchingDateViewBuilder().build(store: self.onethingMatchingStoreForBinding)
        case .home(.onething(.payment)):
            OnethingMatchingPaymentViewBuilder().build(store: self.onethingMatchingStoreForBinding)
        case .home(.onething(.paySuccess)):
            OnethingMatchingCompleteViewBuilder().build(store: self.onethingMatchingStoreForBinding)
        case .home(.onething(.payFail)):
            OnethingMatchingFailViewBuilder().build(store: self.onethingMatchingStoreForBinding)

        case .home(.random(.main)):
            RandomMatchingMainViewBuilder().build(store: self.randomMatchingStoreForBinding)
        case .home(.random(.location)):
            RandomMatchingLocationViewBuilder().build(store: self.randomMatchingStoreForBinding)
        case .home(.random(.topic)):
            RandomMatchingTopicViewBuilder().build(store: self.randomMatchingStoreForBinding)
        case .home(.random(.tmi)):
            RandomMatchingTMIViewBuilder().build(store: self.randomMatchingStoreForBinding)
        case .home(.random(.payment)):
            RandomMatchingPaymentViewBuilder().build(store: self.randomMatchingStoreForBinding)
        case .home(.random(.complete)):
            RandomMatchingCompleteViewBuilder().build(store: self.randomMatchingStoreForBinding)
            
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

private struct HomeCoordinatorKey: EnvironmentKey {
    // static var defaultValue: AppCoordinator {
    //     fatalError("FatalError: AppCoordinator not set in environment")
    // }
    static var defaultValue: HomeCoordinator = HomeCoordinator(
        dependencies: AppDIContainer(),
        initialType: .onething
    )
}

extension EnvironmentValues {
    var homeCoordinator: HomeCoordinator {
        get { self[HomeCoordinatorKey.self] }
        set { self[HomeCoordinatorKey.self] = newValue }
    }
}
