//
//  HomeView.swift
//  OneThing
//
//  Created by 윤동주 on 4/4/25.
//

import SwiftUI

struct HomeView: View {
    
    enum Constants {
        enum Text {
            static let requestMeetingTitle: String = "모임 신청"
            
            static let meetingReviewAlertTitle: String = "후기를 작성하러 갈까요?"
            static let meetingReviewAlertMessage: String = "원띵모임"
            static let meetingReviewAlertConfirmButtonTitle: String = "후기 남기기"
            static let meetingReviewAlertCancelButtonTitle: String = "다음에 작성하기"
        }
        
        static let timerInterval: TimeInterval = 4
    }
    
    @Environment(\.appCoordinator) var appCoordinator
    @Environment(\.homeCoordinator) var homeCoordinator
    
    @Binding var store: HomeStore
    
    @State private var isPresentedPreparingAlert: Bool = false
    @State private var isMeetingReviewAlertPresented: Bool = false
    
    private let rows = [GridItem()]
    
    var body: some View {
        
        OTBaseView(String(describing: Self.self), background: .gray100) {
            
            ZStack {
                
                VStack {
                    
                    
                    // MARK: Notice
                    
                    NoticeView(notices: self.store.state.noticeInfos)
                    
                    
                    // MARK: Top Banner + Matched Meeting + Request Meeting + Bottom Banner
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        // 내부 요소만 offset을 주기 위해 VStack으로 감싸줌
                        VStack(spacing: 40) {
                            
                            
                            // MARK: Top Banner
                            
                            TopBannerView(
                                bannerInfos: self.store.state.topBannerInfos,
                                onCloseTapped: { bannerId in
                                    Task {
                                        await self.store.send(.updateTopBannerStatus(bannerId))
                                    }
                                }
                            )
                            
                            
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
                                            .otFont(.title1(with: .black))
                                            .foregroundStyle(.purple400)
                                    }
                                }
                                .padding(.horizontal, 16)
                                
                                if matchingSummariesWithType.isEmpty {
                                    HomeGridEmptyAndFooter(category: .placeholder)
                                        .padding(.horizontal, 16)
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
                                        .padding(.horizontal, 16)
                                    }
                                }
                            }
                            
                            
                            // MARK: Request Meeting
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text(Constants.Text.requestMeetingTitle)
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
                                            self.homeCoordinator.nicknameForRandomMatching = self.store.state.nickname
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
                            
                            
                            // MARK: Bottom Banner
                            
                                
                            BottomBannerView(bannerInfos: self.store.state.bannerInfos)
                            
                            Spacer().frame(height: 32)
                        }
                        // 새로고침 시 내부 컨텐츠에만 offset 추가
                        .offset(y: self.store.state.isLoading ? 20: 0)
                    }
                    .contentMargins(
                        .top,
                        self.store.state.noticeInfos.isEmpty ? 0: 32,
                        for: .scrollContent
                    )
                    .refreshable {
                        await self.store.send(.refresh)
                        await self.store.send(.matchings)
                    }
                }
                
                
                // MARK: In Meeting floating view
                
                if let reachedMeeting = self.store.state.reachedMeeting {
                    InMeetingFloatingView(
                        onBackgroundTapped: {
                            let inMeetingCoordinator = self.homeCoordinator.childCoordinator.first(
                                    where: { $0 is InMeetingCoordinator }
                                ) as! InMeetingCoordinator
                            inMeetingCoordinator.inMeetingInfo = (
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
        .taskForOnce {
            await self.store.send(.landing)
            await self.store.send(.matchings)
        }
        // 상단 배너 상태가 변경되었을 때, 재 조회
        .task(id: self.store.state.isChangeSuccessForTopBannerStatus) {
            if self.store.state.isChangeSuccessForTopBannerStatus {
                await self.store.send(.topBanners)
            }
        }
        // 모임이 끝난 후, 모임 후기 팝업 표시 및 정보 전달
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
                
                self.homeCoordinator.initialReviewInfo = meetingReviewInfo
                self.homeCoordinator.dismissSheet()
                
                self.isMeetingReviewAlertPresented = true
            }
        }
        // 모임 신청 후 당일 모임이 있는 지 확인
        .onReceive(NotificationCenter.default.publisher(for: .fetchMatchingsForToday)) { _ in
            Task { await self.store.send(.matchings) }
        }
        // 모임 후기 작성 Alert
        .showAlert(
            isPresented: $isMeetingReviewAlertPresented,
            title: Constants.Text.meetingReviewAlertTitle,
            message: Constants.Text.meetingReviewAlertMessage,
            actions: [
                .init(
                    title: Constants.Text.meetingReviewAlertConfirmButtonTitle,
                    style: .primary,
                    action: {
                        self.isMeetingReviewAlertPresented = false
                        self.homeCoordinator.showCover(to: .home(.meetingReview))
                    }
                ),
                .init(
                    title: Constants.Text.meetingReviewAlertCancelButtonTitle,
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

#Preview {
    let homeStoreForPreview = HomeStore(
        getProfileUseCase: GetProfileInfoUseCase(),
        getUnReadNotificationUseCase: GetUnReadNotificationUseCase(),
        getNotificationBannerUseCase: GetNotificationBannerUseCase(),
        updateNotificationBannerUseCase: UpdateNotificationBannerUseCase(),
        noticeUseCase: GetNoticeUseCase(),
        getMatchingStatusUseCase: GetMatchingStatusUseCase(),
        getMatchingsUseCase: GetMatchingsUseCase(),
        bannerUseCase: GetBannerUseCase()
    )
    HomeView(store: .constant(homeStoreForPreview))
}
