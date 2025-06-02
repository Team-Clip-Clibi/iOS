//
//  HomeView.swift
//  OneThing
//
//  Created by 윤동주 on 4/4/25.
//

import SwiftUI

struct HomeView: View {
    
    enum ConstText {
        static let requestMeetingTitle = "모임 신청"
    }
    
    @Binding var appPathManager: OTAppPathManager
    @Binding var viewModel: HomeViewModel
    
    @State private var topBannerCurrPage: Int = 0
    @State private var currentPage: Int = 0
    
    private let rows = [GridItem()]
    
    var body: some View {
        
        NavigationStack(path: $appPathManager.homePaths) {
            
            ZStack {
                Color.gray100.ignoresSafeArea()
                
                // 네비게이션 바 + 공지/새소식
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
                    
                    // 상단 배너 + 매칭된 모임 + 모임 신청 + 하단 배너
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        // 상단 배너
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
                        
                        // 매칭된 모임
                        VStack(alignment: .leading, spacing: 12) {
                            let matchingSummaryInfos = self.viewModel.currentState.matchingSummaryInfos
                            
                            HStack(spacing: 10) {
                                Text("임시의 모임")
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
                        
                        // 모임 신청
                        VStack(alignment: .leading, spacing: 12) {
                            Text(ConstText.requestMeetingTitle)
                                .otFont(.title1)
                                .foregroundStyle(.gray700)
                            
                            RequestMeetingButton(
                                category: .onething,
                                backgroundTapAction: {
                                    self.appPathManager.isTabBarHidden = true
                                    
                                    if UserDefaults.isFirstMatching {
                                        self.appPathManager.nextPathWhenInitialFinished = .oneThing
                                        self.appPathManager.push(path: .initial(.main))
                                    } else {
                                        self.appPathManager.push(path: .oneThing(.main))
                                    }
                                }
                            )
                            
                            HStack(spacing: 10) {
                                RequestMeetingButton(
                                    category: .random,
                                    backgroundTapAction: {
                                        self.appPathManager.isTabBarHidden = true
                                        
                                        if UserDefaults.isFirstMatching {
                                            self.appPathManager.nextPathWhenInitialFinished = .random
                                            self.appPathManager.push(path: .initial(.main))
                                        } else {
                                            self.appPathManager.push(path: .random(.main))
                                        }
                                    }
                                )
                                RequestMeetingButton(category: .instant, backgroundTapAction: { })
                            }
                        }
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        
                        Spacer().frame(height: 40)
                        
                        // 하단 배너
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
                    // TODO: 새로고침 시 contentOffset 필요
                     .refreshable {
                         await self.viewModel.isUnReadNotificationEmpty()
                         await self.viewModel.topBanners()
                         await self.viewModel.notice()
                         await self.viewModel.matchingSummary()
                         await self.viewModel.banners()
                     }
                }
            }
            .task {
                await self.viewModel.isUnReadNotificationEmpty()
                await self.viewModel.topBanners()
                await self.viewModel.notice()
                await self.viewModel.matchingSummary()
                await self.viewModel.banners()
            }
            .task(id: self.viewModel.currentState.isChangeSuccessForTopBannerStatus) {
                if self.viewModel.currentState.isChangeSuccessForTopBannerStatus {
                    await self.viewModel.topBanners()
                }
            }
        }
        
    }
}

extension HomeView {
    
    private func setupBanner(with urlString: String) -> some View {
        
        AsyncImage(url: URL(string: urlString)) { phase in
            switch phase {
            case let .success(image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 110)
            default:
                EmptyView()
            }
        }
    }
    
    private func setupIndicator() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(.purple400)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(.gray400)
    }
}

// #Preview {
//      HomeView(
//         appPathManager: .constant(OTAppPathManager()),
//         viewModel: .constant(HomeViewModel())
//     )
// }
