//
//  LaunchScreenStore.swift
//  OneThing
//
//  Created by 오현식 on 8/2/25.
//

import Foundation

import KakaoSDKCommon

@Observable
class LaunchScreenStore: OTStore {
    
    enum Action: OTAction {
        case launch
    }
    
    enum Process: OTProcess {
        case updateIsLaunched(Bool)
    }
    
    struct State: OTState {
        fileprivate(set) var isLaunched: Bool
    }
    var state: State
    
    private let sessionStore: SessionStoring
    private let authRepository: AuthRepository
    private let appStateManager: AppStateManager
    
    init(
        sessionStore: SessionStoring,
        authRepository: AuthRepository,
        appStateManager: AppStateManager
    ) {
        
        self.state = State(isLaunched: false)
        
        self.sessionStore = sessionStore
        self.authRepository = authRepository
        self.appStateManager = appStateManager
        
        self.initalSetupForKakao()
    }
    
    func process(_ action: Action) async -> OTProcessResult<Process> {
        switch action {
        case .launch:
            return await self.initialSetup()
        }
    }
    
    func reduce(state: State, process: Process) -> State {
        var newState = state
        switch process {
        case let .updateIsLaunched(isLaunched):
            newState.isLaunched = isLaunched
        }
        return newState
    }
}

private extension LaunchScreenStore {
    
    func initalSetupForKakao() {
        
        let kakaoNativeAppKey = (Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String) ?? ""
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
    }
    
    func initialSetup() async -> OTProcessResult<Process> {
        
        let socialId = self.sessionStore.socialId ?? ""
        let platform = self.sessionStore.platform ?? ""
        let firebaseToken = self.sessionStore.firebaseToken ?? ""
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
        
        let signInDTO = SignInDTO(
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
            
            try await NotificationManager.shared.requestAuthorization()
            HapticManager.shared.setEnable(true)
            
            self.appStateManager.isSignedIn = true
            return .single(.updateIsLaunched(true))
        } catch {
            self.appStateManager.isSignedIn = false
            return .single(.updateIsLaunched(true))
        }
    }
}
