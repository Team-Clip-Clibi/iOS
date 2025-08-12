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
        static let meetingReviewAlertMessage: String = "원띵모임"
        static let meetingReviewAlertConfirmButtonTitle: String = "후기 남기기"
        static let meetingReviewAlertCancelButtonTitle: String = "다음에 작성하기"
    }
    
    @Environment(\.appCoordinator) var appCoordinator
    @Environment(\.homeCoordinator) var homeCoordinator
    
    @Binding var store: HomeStore
    
    @State private var topBannerCurrPage: Int = 0
    @State private var currentPage: Int = 0
    
    @State private var isPresentedPreparingAlert: Bool = false
    @State private var isMeetingReviewAlertPresented: Bool = false
    
    private let dateManager = DateComparisonManager()
    
    private let rows = [GridItem()]
    
    var body: some View {
        
        OTBaseView(String(describing: Self.self), background: .gray100) {
            
            ZStack {
                // MARK: NavigationBar + Notice
                
                NoticeView(notices: self.store.state.noticeInfos)
                
                
                // MARK: Top Banner + Matched Meeting + Request Meeting + Bottom Banner
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    
                    // MARK: Top Banner
                    
                    if self.store.state.topBannerInfos.isEmpty {
                        EmptyView()
                    } else {
                        ZStack {
                            TabView {
                                ForEach(
                                    Array(self.store.state.topBannerInfos.enumerated()),
                                    id: \.offset
                                ) { page, bannerInfo in
                                    TopBannerView(
                                        description: bannerInfo.bannerType.description,
                                        title: bannerInfo.bannerType.title,
                                        currentPage: page,
                                        totalPage: self.store.state.topBannerInfos.count,
                                        closeTapAction: {
                                            Task {
                                                await self.store.send(.updateTopBannerStatus(bannerInfo.id))
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
                        let matchingSummariesWithType = self.store.state.matchingSummariesWithType
                        
                        HStack(spacing: 10) {
                            // TODO: 임시, 유저 정보는 전역으로 관리 필요
                            Text("\(self.store.state.nickname)의 모임")
                                .otFont(.title1)
                                .foregroundStyle(.gray700)
                            
                            if matchingSummariesWithType.isEmpty {
                                EmptyView()
                            } else {
                                Text("\(matchingSummariesWithType.count)")
                                // TODO: weight 조절 추가해야 함
                                    .otFont(.title1)
                                    .foregroundStyle(.purple400)
                            }
                        }
                        
                        if matchingSummariesWithType.isEmpty {
                            HomeGridEmptyAndFooter(category: .placeholder)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHGrid(rows: self.rows) {
                                    ForEach(
                                        matchingSummariesWithType,
                                        id: \.info.matchingId
                                    ) { matchingSummaryInfo in
                                        HomeGridItem(
                                            matchingType: matchingSummaryInfo.type,
                                            matchingSummary: matchingSummaryInfo.info
                                        )
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
                            matchingType: .onething,
                            backgroundTapAction: {
                                self.homeCoordinator.willPushedMatchingType = .onething
                                self.homeCoordinator.push(
                                    to: UserDefaults.isFirstMatching ?
                                        .home(.initial(.main)) :
                                        .home(.onething(.main))
                                )
                            }
                        )
                        
                        HStack(spacing: 12) {
                            RequestMeetingButton(
                                matchingType: .random,
                                backgroundTapAction: {
                                    self.homeCoordinator.willPushedMatchingType = .random
                                    self.homeCoordinator.push(
                                        to: UserDefaults.isFirstMatching ?
                                            .home(.initial(.main)) :
                                            .home(.random(.main))
                                    )
                                }
                            )
                            RequestMeetingButton(
                                matchingType: .instant,
                                backgroundTapAction: { self.isPresentedPreparingAlert = true }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    
                    // MARK: Bottom Banner
                    
                    VStack(spacing: 10) {
                        TabView(selection: $currentPage) {
                            ForEach(
                                0..<self.store.state.bannerInfos.count,
                                id: \.self
                            ) { page in
                                let urlString = self.store.state.bannerInfos[page].urlString
                                self.setupBanner(with: urlString)
                                    .tag(page)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        
                        HStack(spacing: 6) {
                            ForEach(
                                0..<self.store.state.bannerInfos.count,
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
                .padding(.top, self.store.state.noticeInfos.isEmpty ? 0: 32)
                // .padding(.bottom, 32)
                // TODO: 새로고침 시 contentOffset 필요
                .refreshable { await self.store.send(.refresh) }
                
                
                // MARK: In Meeting floating view
                
                if let reachedMeeting = self.store.state.reachedMeeting {
                    InMeetingFloatingView(
                        onBackgroundTapped: {
                            self.homeCoordinator.inMeetingInfo = (
                                matchingId: reachedMeeting.matchingId,
                                matchingType: reachedMeeting.matchingType
                            )
                            self.homeCoordinator.showSheet(to: .home(.inMeeting(.main)))
                        }
                    )
                        .padding(.bottom, 12)
                        .padding(.horizontal, 16)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
        }
        .navigationBar(
            titleAlignment: .left,
            titleView: AnyView(
                Image(.logoBlack)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 24)
            ),
            hidesBackButton: true,
            rightButtons: [
                AnyView(
                    Button(action: {
                        self.homeCoordinator.push(to: .home(.notification))
                    }, label: {
                        Image(self.store.state.isUnReadNotiEmpty ? .bellOutlined: .bellUnread)
                            .resizable()
                            .frame(width: 24, height: 24)
                    })
                )
            ],
            backgroundColor: .gray100
        )
        .taskForOnce { await self.store.send(.landing) }
        .task(id: self.store.state.isChangeSuccessForTopBannerStatus) {
            if self.store.state.isChangeSuccessForTopBannerStatus {
                await self.store.send(.topBanners)
            }
        }
        .onChange(of: self.store.state.hasMeeting.last) { _, new in
            
            if let hasMeeting = new, hasMeeting.meetingTime.isToday {
                
                self.dateManager.startMonitoring(
                    with: hasMeeting.meetingTime,
                    onTimeRangeChanged: { isWithinRange in
                        if isWithinRange {
                            Task { await self.store.send(.reachedMeetingTime(hasMeeting)) }
                        }
                    },
                    onTimeExceeded: {
                        Task { await self.store.send(.reachedMeetingTime(nil)) }
                    }
                )
            } else {
                
                self.dateManager.stopMonitoring()
                Task { await self.store.send(.reachedMeetingTime(nil)) }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .showMeetingReviewAlert)) { notification in
            if let notiObject = notification.object as? [String: Any],
               let nicknames = notiObject["nicknames"] as? [String],
               let matchingId = notiObject["matchingId"] as? String,
               let matchingType = notiObject["matchingType"] as? MatchingType {
                
                let meetingReviewInfo = MeetingReviewStore.InitialInfo(
                    nicknames: nicknames,
                    matchingId: matchingId,
                    matchingtype: matchingType
                )
                
                self.isMeetingReviewAlertPresented = true
                self.homeCoordinator.initialReviewInfo = meetingReviewInfo
            }
        }
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
                        self.isMeetingReviewAlertPresented = false
                        self.homeCoordinator.showCover(to: .home(.meetingReview))
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
        // 번개 모임 준비중 Alert
        .showPreparing(isPresented: $isPresentedPreparingAlert)
    }
}


private extension HomeView {
    
    func setupBanner(with urlString: String) -> some View {
        
        AsyncSVGImage(urlString: urlString, shape: .rounded(8))
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .frame(height: 110)
            .disabled(true)
    }
}

// #Preview {
//      HomeView(
//         appPathManager: .constant(OTAppPathManager()),
//         viewModel: .constant(HomeViewModel()),
//         inMeetingPathManager: .constant(OTInMeetingPathManager())
//     )
// }
