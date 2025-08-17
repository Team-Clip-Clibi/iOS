//
//  MainTabBarView.swift
//  OneThing
//
//  Created by 오현식 on 8/2/25.
//

import SwiftUI

struct MainTabBarView: View {
    
    enum Constants {
        enum Text {
            static let homeTabTitle =       "홈"
            static let myMeetingTabTitle =  "내 모임"
            static let myTabTitle =         "마이"
        }
        
        enum Image {
            static let homeTabImage =       ImageResource.homeFill
            static let myMeetingTabImage =  ImageResource.myMeetingFill
            static let myTabImage =         ImageResource.myFill
        }
    }
    
    @Environment(\.appCoordinator) var appCoordinator
    
    private var coordinator: MainTabBarCoordinator {
        return self.appCoordinator.childCoordinator.first(
            where: { $0 is MainTabBarCoordinator }
        ) as! MainTabBarCoordinator
    }
    
    private var homeCoordinator: HomeCoordinator {
        return self.coordinator.childCoordinator.first(
            where: { $0 is HomeCoordinator }
        ) as! HomeCoordinator
    }
    private var inMeetingCoordinator: InMeetingCoordinator {
        return self.homeCoordinator.childCoordinator.first(
            where: { $0 is InMeetingCoordinator }
        ) as! InMeetingCoordinator
    }
    
    private var myPageCoordinator: MyPageCoordinator {
        return self.coordinator.childCoordinator.first(
            where: { $0 is MyPageCoordinator }
        ) as! MyPageCoordinator
    }
    
    var body: some View {
        
        @Bindable var coordinatorForBinding = self.coordinator
        @Bindable var homeCoordinatorForBinding = self.homeCoordinator
        @Bindable var inMeetingCoordinatorForBinding = self.inMeetingCoordinator
        @Bindable var myPageCoordinatorForBinding = self.myPageCoordinator
        
        TabView(selection: $coordinatorForBinding.currentTab) {
            
            NavigationStack(path: $homeCoordinatorForBinding.path) {
                self.homeCoordinator.start()
                    .navigationDestination(for: OTPath.self) { path in
                        self.homeCoordinator.destinationView(to: path)
                            // HomeView에서 화면 전환 했을 때, tabBar 숨김
                            .toolbar(.hidden, for: .tabBar)
                    }
                    // 모임 후기 cover
                    .fullScreenCover(item: $homeCoordinatorForBinding.cover) { _ in
                        self.homeCoordinator.presentMeetingReview()
                    }
                    // 모임 중 Sheet
                    .showInMeetingSheet(
                        isPresented: Binding(
                            get: { homeCoordinatorForBinding.sheet == .home(.inMeeting(.main)) },
                            set: { _ in }
                        )
                    ) {
                        Group {
                            if self.inMeetingCoordinator.path.isEmpty {
                                self.inMeetingCoordinator.start()
                            } else {
                                // inMeetingCoordinator > path가 비어있지 않으면 경로가 반드시 존재한다고 가정
                                self.inMeetingCoordinator.destinationView(
                                    to: self.inMeetingCoordinator.path.last!
                                )
                            }
                        }
                        // 모임 중 sheet을 표시할 때, tabBar 숨김
                        .toolbar(.hidden, for: .tabBar)
                        .environment(\.inMeetingCoordinator, inMeetingCoordinatorForBinding)
                    }
            }
            .environment(\.homeCoordinator, homeCoordinatorForBinding)
            .tabItem {
                OTTabItem(
                    title: Constants.Text.homeTabTitle,
                    imageResource: Constants.Image.homeTabImage
                )
            }
            .tag(0)
            
            Text("내 모임 화면")
                .tabItem {
                    OTTabItem(
                        title: Constants.Text.myMeetingTabTitle,
                        imageResource: Constants.Image.myMeetingTabImage
                    )
                }
                .tag(1)
            
            NavigationStack(path: $myPageCoordinatorForBinding.path) {
                self.myPageCoordinator.start()
                    .navigationDestination(for: OTPath.self) { path in
                        self.myPageCoordinator.destinationView(to: path)
                            // MyPage에서 화면 전환 했을 때, tabBar 숨김
                            .toolbar(.hidden, for: .tabBar)
                    }
                    // 내 정보 수정 cover
                    .fullScreenCover(item: $myPageCoordinatorForBinding.cover) { path in
                        self.myPageCoordinator.destinationEditView(to: path)
                    }
            }
            .environment(\.myPageCoordinator, myPageCoordinatorForBinding)
            .tabItem {
                OTTabItem(
                    title: Constants.Text.myTabTitle,
                    imageResource: Constants.Image.myTabImage
                )
            }
            .tag(2)
        }
        // TODO: 임시, 선택된 탭 이미지 색상
        .accentColor(.gray800)
        .onAppear() {
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = .white100
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    MainTabBarView()
}
