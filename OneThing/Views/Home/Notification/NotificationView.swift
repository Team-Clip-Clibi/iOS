//
//  NotificationView.swift
//  OneThing
//
//  Created by 오현식 on 5/10/25.
//

import SwiftUI

struct NotificationView: View {
    
    enum ConstText {
        static let title = "알림"
        static let placeholderText = "새로운 알림이 없어요"
        static let unReadTitle = "새로운 알림"
        static let readTitle = "한 번 더 확인해요"
        static let bottomInfoText = "30일 전 알림까지 확인할 수 있어요"
    }
    
    @Binding var appPathManager: OTAppPathManager
    @Binding var viewModel: NotificationViewModel
    
    private let columns = [GridItem()]
    
    var body: some View {
        
        VStack {
            
            NavigationBar()
                .title(ConstText.title)
                .hidesBottomSeparator(false)
                .onBackButtonTap {
                    self.appPathManager.pop()
                }
            
            ScrollView(.vertical, showsIndicators: false) {
                
                if self.viewModel.currentState.isNotificationEmpty {
                    
                    VStack(alignment: .center, spacing: 12) {
                        Image(.circleInBell)
                            .resizable()
                            .frame(width: 60, height: 60)
                        
                        Text(ConstText.placeholderText)
                            .otFont(.body1)
                            .foregroundStyle(.gray500)
                    }
                    // TODO: 임시, VStack 중앙 정렬 필요
                    .padding(.top, 200)
                } else {
                    
                    // 읽지 않은 알림
                    if self.viewModel.currentState.unReadNotificationInfos.isEmpty == false {
                        VStack(spacing: 4) {
                            Text(ConstText.unReadTitle)
                                .otFont(.title1)
                                .foregroundStyle(.gray800)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            LazyVGrid(columns: self.columns) {
                                ForEach(
                                    self.viewModel.currentState.unReadNotificationInfos,
                                    id: \.id
                                ) { notification in
                                    NotificationGridItem(notification: notification, isNew: true)
                                        .task {
                                            guard self.viewModel.currentState.isLoadMore == false,
                                                  notification == self.viewModel.currentState.unReadNotificationInfos.last
                                            else { return }
                                            
                                            await self.viewModel.moreUnReadNotifications(with: notification.id)
                                        }
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity)
                    }
                    
                    if self.viewModel.currentState.unReadNotificationInfos.isEmpty == false {
                        Spacer().frame(height: 24)
                    }
                    
                    // 읽은 알림
                    if self.viewModel.currentState.readNotificationInfos.isEmpty == false {
                        VStack(spacing: 4) {
                            Text(ConstText.readTitle)
                                .otFont(.title1)
                                .foregroundStyle(.gray800)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            LazyVGrid(columns: self.columns) {
                                ForEach(
                                    self.viewModel.currentState.readNotificationInfos,
                                    id: \.id
                                ) { notification in
                                    NotificationGridItem(notification: notification, isNew: false)
                                        .task {
                                            guard self.viewModel.currentState.isLoadMore == false,
                                                  notification == self.viewModel.currentState.readNotificationInfos.last
                                            else { return }
                                            
                                            await self.viewModel.moreReadNotifications(with: notification.id)
                                        }
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity)
                    }
                    
                    // 하단 알림 정보
                    HStack(spacing: 12) {
                        Rectangle()
                            .frame(width: nil, height: 1, alignment: .center)
                            .foregroundStyle(.gray200)
                        
                        Text(ConstText.bottomInfoText)
                            .otFont(.body1)
                            .foregroundStyle(.gray600)
                            .layoutPriority(1)
                        
                        Rectangle()
                            .frame(width: nil, height: 1, alignment: .center)
                            .foregroundStyle(.gray200)
                    }
                    .padding(.vertical, 24)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity)
                }
            }
            .ignoresSafeArea(.container, edges: .bottom)
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
            .refreshable {
                await self.viewModel.notifications()
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            self.appPathManager.isTabBarHidden = true
        }
        .onDisappear {
            self.appPathManager.isTabBarHidden = false
        }
        .task {
            await self.viewModel.notifications()
        }
    }
}

#Preview {
    NotificationView(
        appPathManager: .constant(OTAppPathManager()),
        viewModel: .constant(NotificationViewModel())
    )
}
