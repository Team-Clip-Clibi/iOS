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
    
    @State private var myPageViewModel = MyPageEditViewModel()
    
    @Binding var pathManager: OTAppPathManager
    
    init(pathManager: Binding<OTAppPathManager>) {
        self._pathManager = pathManager
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 콘텐츠 영역
            ZStack {
                switch pathManager.currentTab {
                case .home:
                    NavigationStack(path: $pathManager.homePaths) {
                        HomeView(appPathManager: $pathManager)
                            .navigationDestination(for: OTHomePath.self) { homePath in
                                switch homePath {
                                default:
                                    EmptyView()
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
                                case .report:
                                    MyPageEditLanguageView(
                                        pathManager: $pathManager,
                                        viewModel: $myPageViewModel
                                    )
                                case .reportMatching:
                                    MyPageEditLanguageView(
                                        pathManager: $pathManager,
                                        viewModel: $myPageViewModel
                                    )
                                case .reportReason:
                                    MyPageEditLanguageView(
                                        pathManager: $pathManager,
                                        viewModel: $myPageViewModel
                                    )
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
