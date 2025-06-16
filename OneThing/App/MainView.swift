//
//  MainView.swift
//  OneThing
//
//  Created by 윤동주 on 3/23/25.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

struct MainView: View {
    @Environment(AppStateManager.self) var appStateManager

    @State var authPathManager = OTAuthPathManager()
    
    @State var appPathManager = OTAppPathManager()
    
    @State var inMeetingPathManager = OTInMeetingPathManager()
    
    init() {
        let kakaoNativeAppKey = (Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String) ?? ""
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
    }
    
    var body: some View {
        SignUpContainer
            .onChange(of: appStateManager.isSignedIn) { _, _ in
                /// 로그아웃 or 탈퇴 후 다시 로그인할 경우 Home 탭이 먼저 깔리도록 설정
                appPathManager.currentTab = .home
            }
    }
}

extension MainView {
    @ViewBuilder
    private var SignUpContainer: some View {
        if appStateManager.isSignedIn {
            OTTabBarContainer(pathManager: $appPathManager, inMeetingPathManager: $inMeetingPathManager)
        } else {
            SignUpMainView(authPathManager: $authPathManager)
                .onOpenURL(perform: { url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                })
        }
    }
}
