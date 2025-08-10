//
//  OneThingApp.swift
//  OneThing
//
//  Created by 윤동주 on 3/15/25.
//

import SwiftUI

import KakaoSDKAuth

@main
struct OneThingApp: App {
    
    // Firebase 설정을 위한 AppDelegate 등록
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State private var appCoordinator: AppCoordinator = AppCoordinator(dependencies: AppDIContainer())
    
    var body: some Scene {
        WindowGroup {
            Group {
                
                self.appCoordinator.start()
                    .onOpenURL { url in
                        if AuthApi.isKakaoTalkLoginUrl(url) { _ = AuthController.handleOpenUrl(url: url)}
                    }
            }
            .environment(\.appCoordinator, self.appCoordinator)
        }
    }
}

extension String {
    func randomString(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).compactMap { _ in characters.randomElement() })
    }
}
