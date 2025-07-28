//
//  OneThingApp.swift
//  OneThing
//
//  Created by 윤동주 on 3/15/25.
//

import SwiftUI

@main
struct OneThingApp: App {
    // Firebase 설정을 위한 AppDelegate 등록
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State var appStateManager = AppStateManager()
    @State var isReady = false
    
    private let sessionStore: SessionStoring = UserDefaultsSessionStore()
    private let authRepository = AuthRepository()
    
    var body: some Scene {
        WindowGroup {
            if isReady {
                MainView()
                    .toolbar(.hidden, for: .navigationBar)
                    .environment(appStateManager)
            } else {
                LaunchScreenWrapper()
                    .ignoresSafeArea(.all)
                    .onAppear {
                        Task {
                            try await performInitialSetup()
                            // 초기 설정 작업 완료 후 isReady 업데이트
                            isReady = true
                        }
                    }
            }
        }
    }
    
    private func performInitialSetup() async throws {
        let socialId = sessionStore.socialId ?? ""
        let platform = sessionStore.platform ?? ""
        let firebaseToken = sessionStore.firebaseToken ?? ""
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
        
        let signInDTO = SignInDTO(
//            socialId: "".randomString(length: 10),
            socialId: socialId,
            platform: platform,
            osVersion: version,
            firebaseToken: firebaseToken,
            isAllowNotify: true
        )
        
        do {
            let response = try await authRepository.usersSignIn(with: signInDTO)
            TokenManager.shared.accessToken = response.accessToken
            TokenManager.shared.refreshToken = response.refreshToken
            
            self.appStateManager.isSignedIn = true
        } catch {
            self.appStateManager.isSignedIn = false
        }
        
        try await NotificationManager.shared.requestAuthorization()
        HapticManager.shared.setEnable(true)
    }
}

struct LaunchScreenWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "Launch Screen", bundle: nil)
        return storyboard.instantiateInitialViewController() ?? UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}

extension String {
    func randomString(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).compactMap { _ in characters.randomElement() })
    }
}
