//
//  HomeView.swift
//  OneThing
//
//  Created by 윤동주 on 4/4/25.
//

import SwiftUI

struct HomeView: View {
    
    enum ConstText {
        static let requestMeetingTitle: String = "모임 신청"
        
        static let meetingReviewAlertTitle: String = "후기를 작성하러 갈까요?"
        static let meetingReviewAlertMessage: String = "4월 15일 원띵모임"
        static let meetingReviewAlertConfirmButtonTitle: String = "후기 남기기"
        static let meetingReviewAlertCancelButtonTitle: String = "다음에 작성하기"
    }
    
    @Binding var appPathManager: OTAppPathManager
    @Binding var viewModel: HomeViewModel
    
    @Binding var inMeetingPathManager: OTInMeetingPathManager
    
    @State private var topBannerCurrPage: Int = 0
    @State private var currentPage: Int = 0
    
    @State private var isPresentedPreparingAlert: Bool = false
    @State private var isInMeetingSheetPresented: Bool = false
    @State private var isMeetingReviewAlertPresented: Bool = false
    
    private let dateManager = DateComparisonManager()
    
    private let rows = [GridItem()]
    
    var body: some View {
        
        NavigationStack(path: $appPathManager.homePaths) {
            
            ZStack {
                Color.gray100.ignoresSafeArea()
                
                
                // MARK: NavigationBar + Notice
                
                VStack {
                    NavigationBar()
                        .hidesBackButton(true)
                        .titleView(
                            Image(.logoBlack)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 24)
                        )
                        .titleAlignment(.left)
                        .rightButtons([
                            Button(action: {
                                self.appPathManager.push(path: OTHomePath.notification)
                            }, label: {
                                Image(self.viewModel.currentState.isUnReadNotificationEmpty ? .bellOutlined: .bellUnread)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            })
                        ])
                    
                    NoticeView(notices: self.viewModel.currentState.noticeInfos)
                    
                    
                    // MARK: Top Banner + Matched Meeting + Request Meeting + Bottom Banner
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        
                        // MARK: Top Banner
                        
                        if self.viewModel.currentState.topBannerInfos.isEmpty {
                            EmptyView()
                        } else {
                            ZStack {
                                TabView {
                                    ForEach(
                                        Array(self.viewModel.currentState.topBannerInfos.enumerated()),
                                        id: \.offset
                                    ) { page, bannerInfo in
                                        TopBannerView(
                                            description: bannerInfo.type.description,
                                            title: bannerInfo.type.title,
                                            currentPage: page,
                                            totalPage: self.viewModel.currentState.topBannerInfos.count,
                                            closeTapAction: {
                                                Task {
                                                    await self.viewModel.updateTopBannerStatus(
                                                        with: bannerInfo.id
                                                    )
                                                }
                                            }
                                        )
                                        .tag(page)
                                    }
                                }
                                .tabViewStyle(.page(indexDisplayMode: .never))
                            }
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity)
                            .frame(height: 82)
                            
                            Spacer().frame(height: 40)
                        }
                        
                        
                        //MARK: Matched Meeting
                        
                        VStack(alignment: .leading, spacing: 12) {
                            let matchingSummaryInfos = self.viewModel.currentState.matchingSummaryInfos
                            
                            HStack(spacing: 10) {
                                // TODO: 임시, 유저 정보는 전역으로 관리 필요
                                Text("\(self.viewModel.currentState.nickname)의 모임")
                                    .otFont(.title1)
                                    .foregroundStyle(.gray700)
                                
                                 if matchingSummaryInfos.isEmpty {
                                     EmptyView()
                                 } else {
                                     Text("\(matchingSummaryInfos.count)")
                                        // TODO: weight 조절 추가해야 함
                                         .otFont(.title1)
                                         .foregroundStyle(.purple400)
                                 }
                            }
                            
                            if matchingSummaryInfos.isEmpty {
                                HomeGridEmptyAndFooter(category: .placeholder)
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHGrid(rows: self.rows) {
                                        ForEach(
                                            matchingSummaryInfos,
                                            id: \.matchingId
                                        ) { matchingSummaryInfo in
                                            HomeGridItem(matchingSummary: matchingSummaryInfo)
                                        }
                                        
                                        HomeGridEmptyAndFooter(category: .footer)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        
                        Spacer().frame(height: 40)
                        
                        
                        // MARK: Request Meeting
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text(ConstText.requestMeetingTitle)
                                .otFont(.title1)
                                .foregroundStyle(.gray700)
                            
                            RequestMeetingButton(
                                category: .onething,
                                backgroundTapAction: {
                                    
                                    self.appPathManager.withTabBarHiddenThenNavigate {
                                        let nextPath = UserDefaults.isFirstMatching ? OTHomePath.MatchingType.onething: nil
                                        self.appPathManager.nextPathWhenInitialFinished = nextPath
                                        self.appPathManager.push(path: UserDefaults.isFirstMatching ? .initial(.main): .onething(.main))
                                    }
                                }
                            )
                            
                            HStack(spacing: 12) {
                                RequestMeetingButton(
                                    category: .random,
                                    backgroundTapAction: {
                                        
                                        self.appPathManager.withTabBarHiddenThenNavigate {
                                            let nextPath = UserDefaults.isFirstMatching ? OTHomePath.MatchingType.random: nil
                                            self.appPathManager.nextPathWhenInitialFinished = nextPath
                                            self.appPathManager.push(path: UserDefaults.isFirstMatching ? .initial(.main): .random(.main))
                                        }
                                    }
                                )
                                RequestMeetingButton(
                                    category: .instant,
                                    backgroundTapAction: { self.isPresentedPreparingAlert = true }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        
                        Spacer().frame(height: 40)
                        
                        
                        // MARK: Bottom Banner
                        
                        VStack(spacing: 10) {
                            TabView(selection: $currentPage) {
                                ForEach(
                                    0..<self.viewModel.currentState.bannerInfos.count,
                                    id: \.self
                                ) { page in
                                    let urlString = self.viewModel.currentState.bannerInfos[page].urlString
                                    self.setupBanner(with: urlString)
                                        .tag(page)
                                }
                            }
                            .tabViewStyle(.page(indexDisplayMode: .never))
                            
                            HStack(spacing: 6) {
                                ForEach(
                                    0..<self.viewModel.currentState.bannerInfos.count,
                                    id: \.self
                                ) { page in
                                    Circle()
                                        .fill(page == self.currentPage ? .purple400: .gray400)
                                        .frame(width: 6, height: 6)
                                        .animation(.easeInOut(duration: 0.2), value: self.currentPage)
                                }
                            }
                        }
                        // 초기 높이, 이미지 높이 추정 전
                        .frame(height: 136)
                    }
                    .padding(.top, self.viewModel.currentState.noticeInfos.isEmpty ? 0: 32)
                    .padding(.bottom, 32)
                    // TODO: 새로고침 시 contentOffset 필요
                     .refreshable {
                         await withTaskGroup(of: Void.self) { group in
                             group.addTask { await self.viewModel.isUnReadNotificationEmpty() }
                             group.addTask { await self.viewModel.topBanners() }
                             group.addTask { await self.viewModel.notice() }
                             group.addTask { await self.viewModel.matchingSummary() }
                             group.addTask { await self.viewModel.meetingInProgress() }
                             group.addTask { await self.viewModel.banners() }
                         }
                     }
                }
                
                
                // MARK: In Meeting floating view
                
                if self.viewModel.currentState.isInMeeting {
                    InMeetingFloatingView(onBackgroundTapped: { self.isInMeetingSheetPresented = true })
                        .padding(.bottom, 12)
                        .padding(.horizontal, 16)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
            .task {
                await withTaskGroup(of: Void.self) { group in
                    group.addTask { await self.viewModel.profile() }
                    group.addTask { await self.viewModel.isUnReadNotificationEmpty() }
                    group.addTask { await self.viewModel.topBanners() }
                    group.addTask { await self.viewModel.notice() }
                    group.addTask { await self.viewModel.matchingSummary() }
                    group.addTask { await self.viewModel.meetingInProgress() }
                    if self.viewModel.currentState.bannerInfos.isEmpty {
                        group.addTask { await self.viewModel.banners() }
                    }
                }
            }
            .task(id: self.viewModel.currentState.isChangeSuccessForTopBannerStatus) {
                if self.viewModel.currentState.isChangeSuccessForTopBannerStatus {
                    await self.viewModel.topBanners()
                }
            }
            .onChange(of: self.viewModel.currentState.meetingDate) { _, new in
                
                if let meetingDate = new, meetingDate.isToday {
                    
                    self.dateManager.startMonitoring(
                        with: meetingDate,
                        onTimeRangeChanged: { isWithinRange in
                            Task { await self.viewModel.updateIsInMeeting(isWithinRange) }
                        },
                        onTimeExceeded: {
                            Task { await self.viewModel.updateIsInMeeting(false) }
                        }
                    )
                } else {
                    
                    self.dateManager.stopMonitoring()
                    Task { await self.viewModel.updateIsInMeeting(false) }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .showMeetingReviewAlert)) { notification in
                if let notiObject = notification.object as? [String: Any],
                   let nicknames = notiObject["nicknames"] as? [String],
                   let matchingId = notiObject["matchingId"] as? String,
                   let matchingType = notiObject["matchingType"] as? MatchingType {
                    
                    let meetingReviewInfo = MeetingReviewViewModel.InitialInfo(
                        nicknames: nicknames,
                        matchingId: matchingId,
                        matchingtype: matchingType
                    )
                    
                    Task { await self.viewModel.updateMeetingReviewInfo(meetingReviewInfo) }
                    self.isMeetingReviewAlertPresented = true
                }
            }
            // 모임 중 Sheet
            .showInMeetingSheet(
                inMeetingPathManager: $inMeetingPathManager,
                inMeetingVieWModel: self.viewModel.viewModelForInMeeting(),
                isPresented: $isInMeetingSheetPresented
            )
            // 번개 모임 준비중 Alert
            .showPreparing(isPresented: $isPresentedPreparingAlert)
            // 모임 후기 작성 Alert
            .showAlert(
                isPresented: $isMeetingReviewAlertPresented,
                title: ConstText.meetingReviewAlertTitle,
                message: ConstText.meetingReviewAlertMessage,
                actions: [
                    .init(
                        title: ConstText.meetingReviewAlertConfirmButtonTitle,
                        style: .primary,
                        action: {
                            guard let info = self.viewModel.currentState.meetingReviewInfo else { return }
                            self.isMeetingReviewAlertPresented = false
                            self.appPathManager.push(path: .meetingReview(info))
                        }
                    ),
                    .init(
                        title: ConstText.meetingReviewAlertCancelButtonTitle,
                        style: .gray,
                        action: { self.isMeetingReviewAlertPresented = false }
                    )
                ],
                dismissWhenBackgroundTapped: true
            )
        }
    }
}

private extension HomeView {
    
    func setupBanner(with urlString: String) -> some View {
        
        AsyncSVGImage(urlString: urlString)
            .frame(maxWidth: .infinity)
            .frame(height: 110)
    }
}

#Preview {
     HomeView(
        appPathManager: .constant(OTAppPathManager()),
        viewModel: .constant(HomeViewModel()),
        inMeetingPathManager: .constant(OTInMeetingPathManager())
    )
}
