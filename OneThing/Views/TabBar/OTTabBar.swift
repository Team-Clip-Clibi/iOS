//
//  OTTabBar.swift
//  OneThing
//
//  Created by 윤동주 on 4/13/25.
//

import SwiftUI

struct OTTabBar: View {
    @Binding var currentTab: OTAppTab
    
    private let sqoopTabImage = UIImage(named: "homeTab")?.withRenderingMode(.alwaysTemplate) ?? UIImage(systemName: "exclamationmark.triangle")!
    private let exploreTabImage = UIImage(named: "myMeetingTab")?.withRenderingMode(.alwaysTemplate) ?? UIImage(systemName: "exclamationmark.triangle")!
    private let settingsTabImage = UIImage(named: "myTab")?.withRenderingMode(.alwaysTemplate) ?? UIImage(systemName: "exclamationmark.triangle")!
    
    var body: some View {
        HStack {
            TabButton(
                tab: .home,
                label: String(localized: "홈"),
                image: Image(uiImage: sqoopTabImage)
            )
            
            Spacer()
            
            TabButton(
                tab: .myMeeting,
                label: String(localized: "내 모임"),
                image: Image(uiImage: exploreTabImage)
            )
            
            Spacer()
            
            TabButton(
                tab: .my,
                label: String(localized: "마이"),
                image: Image(uiImage: settingsTabImage)
            )
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 48)
        .padding(.top, 8)
        .padding(.bottom, 21)
        .background(.white100)
    }
    
    @ViewBuilder
    private func TabButton(tab: OTAppTab, label: String, image: Image) -> some View {
        Button(action: {
            if tab != self.currentTab {
                withAnimation {
                    currentTab = tab
                }
            }
        }) {
            VStack(spacing: 4) {
                image
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(
                        currentTab == tab
                        ? .gray800
                        : .gray500
                    )
                Text(label)
                    .otFont(.caption1)
                    .fontWeight(.semibold)
                    .foregroundColor(
                        currentTab == tab
                        ? .gray800
                        : .gray500
                    )
            }
        }
        .frame(width: 64, height: 46)
    }
}

struct OTTabBarContainer: View {
    
    @State private var homeViewModel = HomeViewModel()
    @State private var notificationViewModel = NotificationViewModel()
    @State private var initialMatchingViewModel = InitialMatchingViewModel()
    @State private var oneThingMatchingViewModel = OneThingMatchingViewModel()
    @State private var randomMatchingViewModel = RandomMatchingViewModel()
    
    @State private var myPageViewModel = MyPageEditViewModel()
    
    @State private var myPageNotificationViewModel = MyPageNotificationViewModel()
    
    @State private var myPageReportViewModel = MyPageReportViewModel()
    
    @Binding var pathManager: OTAppPathManager
    @Binding var inMeetingPathManager: OTInMeetingPathManager
    
    init(
        pathManager: Binding<OTAppPathManager>,
        inMeetingPathManager: Binding<OTInMeetingPathManager>
    ) {
        self._pathManager = pathManager
        self._inMeetingPathManager = inMeetingPathManager
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 콘텐츠 영역
            ZStack {
                switch pathManager.currentTab {
                case .home:
                    NavigationStack(path: $pathManager.homePaths) {
                        HomeView(
                            appPathManager: $pathManager,
                            viewModel: $homeViewModel,
                            inMeetingPathManager: $inMeetingPathManager
                        )
                            .navigationDestination(for: OTHomePath.self) { homePath in
                                switch homePath {
                                case .notification:
                                    NotificationView(
                                        appPathManager: $pathManager,
                                        viewModel: $notificationViewModel
                                    )
                                    
                                case let .meetingReview(info):
                                    MeetingReviewView(
                                        appPathManager: $pathManager,
                                        viewModel: .constant(MeetingReviewViewModel(initalInfo: info))
                                    )
                                    
                                case .initial(.main):
                                    InitialMatchingMainView(
                                        appPathManager: $pathManager,
                                        viewModel: $initialMatchingViewModel
                                    )
                                case .initial(.job):
                                    InitialMatchingSelectJobView(
                                        appPathManager: $pathManager,
                                        viewModel: $initialMatchingViewModel
                                    )
                                case .initial(.dietary):
                                    InitialMatchingSelectDietaryView(
                                        appPathManager: $pathManager,
                                        viewModel: $initialMatchingViewModel
                                    )
                                case .initial(.language):
                                    InitialMatchingSelectLanguageView(
                                        appPathManager: $pathManager,
                                        viewModel: $initialMatchingViewModel
                                    )
                                    
                                case .onething(.main):
                                    OneThingMatchingMainView(appPathManager: $pathManager)
                                case .onething(.category):
                                    OneThingMatchingCategoryView(
                                        appPathManager: $pathManager,
                                        viewModel: $oneThingMatchingViewModel
                                    )
                                case .onething(.topic):
                                    OneThingMatchingTopicView(
                                        appPathManager: $pathManager,
                                        viewModel: $oneThingMatchingViewModel
                                    )
                                case .onething(.location):
                                    OneThingMatchingLocationView(
                                        appPathManager: $pathManager,
                                        viewModel: $oneThingMatchingViewModel
                                    )
                                case .onething(.price):
                                    OneThingMatchingPriceView(
                                        appPathManager: $pathManager,
                                        viewModel: $oneThingMatchingViewModel
                                    )
                                case .onething(.tmi):
                                    OneThingMatchingTMIView(
                                        appPathManager: $pathManager,
                                        viewModel: $oneThingMatchingViewModel
                                    )
                                case .onething(.date):
                                    OneThingMatchingDateView(
                                        appPathManager: $pathManager,
                                        viewModel: $oneThingMatchingViewModel
                                    )
                                case .onething(.payment):
                                    OneThingMatchingPaymentView(
                                        appPathManager: $pathManager,
                                        viewModel: $oneThingMatchingViewModel
                                    )
                                case .onething(.complete):
                                    OneThingMatchingCompleteView(
                                        appPathManager: $pathManager,
                                        viewModel: $oneThingMatchingViewModel
                                    )
                                    
                                case .random(.main):
                                    RandomMatchingMainView(
                                        appPathManager: $pathManager,
                                        viewModel: $randomMatchingViewModel
                                    )
                                case .random(.location):
                                    RandomMatchingLocationView(
                                        appPathManager: $pathManager,
                                        viewModel: $randomMatchingViewModel
                                    )
                                case .random(.topic):
                                    RandomMatchingTopicView(
                                        appPathManager: $pathManager,
                                        viewModel: $randomMatchingViewModel
                                    )
                                case .random(.tmi):
                                    RandomMatchingTMIView(
                                        appPathManager: $pathManager,
                                        viewModel: $randomMatchingViewModel
                                    )
                                case .random(.payment):
                                    RandomMatchingPaymentView(
                                        appPathManager: $pathManager,
                                        viewModel: $randomMatchingViewModel
                                    )
                                case .random(.complete):
                                    RandomMatchingCompleteView(
                                        appPathManager: $pathManager,
                                        viewModel: $randomMatchingViewModel
                                    )
                                }
                            }
                    }
                case .myMeeting:
                    NavigationStack(path: $pathManager.myMeetingPaths) {
                        MyMeetingView(appPathManager: $pathManager)
                            .navigationDestination(for: OTMyMeetingPath.self) { myMeetingPath in
                                switch myMeetingPath {
                                default:
                                    EmptyView()
                                }
                            }
                    }
                case .my:
                    NavigationStack(path: $pathManager.myPagePaths) {
                        MyPageView(pathManager: $pathManager, viewModel: $myPageViewModel)
                            .navigationDestination(for: OTMyPagePath.self) { myPagePath in
                                switch myPagePath {
                                case .editProfile:
                                    MyPageEditProfileView(
                                        pathManager: $pathManager,
                                        viewModel: $myPageViewModel
                                    )
                                case .editNickName:
                                    MyPageEditNicknameView(
                                        pathManager: $pathManager,
                                        viewModel: $myPageViewModel
                                    )
                                case .editJob:
                                    MyPageEditJobView(
                                        pathManager: $pathManager,
                                        viewModel: $myPageViewModel
                                    )
                                case .editRelationship:
                                    MyPageEditRelationshipView(
                                        pathManager: $pathManager,
                                        viewModel: $myPageViewModel
                                    )
                                case .editDiet:
                                    MyPageEditDietaryView(
                                        pathManager: $pathManager,
                                        viewModel: $myPageViewModel
                                    )
                                case .editLanguage:
                                    MyPageEditLanguageView(
                                        pathManager: $pathManager,
                                        viewModel: $myPageViewModel
                                    )
                                    
                                case .notification:
                                    MyPageNotificationView(
                                        pathManager: $pathManager,
                                        viewModel: $myPageNotificationViewModel
                                    )
                                case .report:
                                    MyPageReportMainView(
                                        pathManager: $pathManager,
                                        viewModel: $myPageReportViewModel
                                    )
                                case .reportMatching:
                                    MyPageReportMatchingView(
                                        pathManager: $pathManager,
                                        viewModel: $myPageReportViewModel
                                    )
                                case .reportReason:
                                    MyPageReportReasonView(
                                        pathManager: $pathManager,
                                        viewModel: $myPageReportViewModel
                                    )
                                case .term:
                                    MyPageTermView(pathManager: $pathManager)
                                }
                            }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            if !pathManager.isTabBarHidden {
                OTTabBar(currentTab: $pathManager.currentTab)
                    .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: pathManager.isTabBarHidden)
        .edgesIgnoringSafeArea(.bottom)
    }
}


#Preview {
    OTTabBar(currentTab: .constant(.home))
    
}
