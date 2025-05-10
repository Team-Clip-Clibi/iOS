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
    
    private let rows = [GridItem()]
    
    var body: some View {
        
        NavigationStack(path: $appPathManager.homePaths) {
            
            ZStack {
                Color.gray100.ignoresSafeArea()
                
                // 네비게이션 바 + 공지/새소식 + 상단 배너
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
                            Button(action: { }, label: {
                                Image(self.viewModel.currentState.isUnReadNotificationEmpty ? .bellOutlined: .bellUnread)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            })
                        ])
                    
                    NoticeView(
                        notices: self.viewModel.currentState.noticeInfos,
                        backgroundTapAction: { }
                    )
                    
                    // TODO: 상단 배너
                    
                    // 매칭된 모임 + 모임 신청 + 하단 배너
                    ScrollView(.vertical, showsIndicators: false) {
                        
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
                            
                            RequestMeetingButton(category: .onething, backgroundTapAction: { })
                            
                            HStack(spacing: 10) {
                                RequestMeetingButton(category: .random, backgroundTapAction: { })
                                RequestMeetingButton(category: .instant, backgroundTapAction: { })
                            }
                        }
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        
                        Spacer().frame(height: 40)
                        
                        // TODO: 하단 배너, 임시 색상으로 표시
                        TabView {
                            Color.purple400
                                .padding(.bottom, 26)
                                .frame(height: 110)
                            Color.green100
                                .padding(.bottom, 26)
                                .frame(height: 110)
                            Color.yellow100
                                .padding(.bottom, 26)
                                .frame(height: 110)
                        }
                        // 배너 높이 + 하단 마진 + 인디케이터 높이
                        .frame(height: 136)
                        .onAppear { self.setupIndicator() }
                        .tabViewStyle(.page(indexDisplayMode: .always))
                    }
                     .padding(.top, 32)
                    // TODO: 새로고침 시 contentOffset 필요
                     .refreshable {
                         await self.viewModel.isUnReadNotificationEmpty()
                         await self.viewModel.notice()
                         await self.viewModel.matchingSummary()
                     }
                }
            }
            .task {
                await self.viewModel.isUnReadNotificationEmpty()
                await self.viewModel.notice()
                await self.viewModel.matchingSummary()
            }
        }
        
    }
}

extension HomeView {
    
    private func setupIndicator() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(.purple400)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(.gray400)
    }
}

#Preview {
     HomeView(
        appPathManager: .constant(OTAppPathManager()),
        viewModel: .constant(HomeViewModel())
    )
}
