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
    
    var body: some View {
        
        let coordinator = self.appCoordinator.childCoordinator.first(
            where: { $0 is MainTabBarCoordinator }
        ) as! MainTabBarCoordinator
        @Bindable var coordinatorForBinding = coordinator
        
        let homeCoordinator = coordinator.childCoordinator.first(
            where: { $0 is HomeCoordinator }
        ) as! HomeCoordinator
        @Bindable var homeCoordinatorForBinding = homeCoordinator
        @State var hasInMeetingSheet = homeCoordinator.sheet == .home(.inMeeting(.main))
        
        let myPageCoordinator = coordinator.childCoordinator.first(
            where: { $0 is MyPageCoordinator }
        ) as! MyPageCoordinator
        @Bindable var myPageCoordinatorForBinding = myPageCoordinator
        
        TabView(selection: $coordinatorForBinding.currentTab) {
            
            NavigationStack(path: $homeCoordinatorForBinding.path) {
                homeCoordinator.start()
                    .navigationDestination(for: OTPath.self) { path in
                        homeCoordinator.destinationView(to: path)
                            // HomeView에서 화면 전환 했을 때, tabBar 숨김
                            .toolbar(.hidden, for: .tabBar)
                    }
                    // 모임 후기 cover
                    .fullScreenCover(item: $homeCoordinatorForBinding.cover) { _ in
                        homeCoordinator.presentMeetingReview()
                    }
                    // 모임 중 Sheet
                    .showInMeetingSheet(
                        isPresented: Binding(
                            get: { homeCoordinatorForBinding.sheet == .home(.inMeeting(.main)) },
                            set: { _ in }
                        )
                    )
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
                myPageCoordinator.start()
                    .navigationDestination(for: OTPath.self) { path in
                        myPageCoordinator.destinationView(to: path)
                            // MyPage에서 화면 전환 했을 때, tabBar 숨김
                            .toolbar(.hidden, for: .tabBar)
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
