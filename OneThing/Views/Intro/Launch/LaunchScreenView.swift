//
//  LaunchScreenView.swift
//  OneThing
//
//  Created by 오현식 on 8/2/25.
//

import SwiftUI

struct LaunchScreenView: View {
    
    @Environment(\.appCoordinator) var appCoordinator
    
    @Binding var store: LaunchScreenStore
    
    var body: some View {
        
        LaunchScreenWrapper()
            .ignoresSafeArea(.all)
            .task {
                // TODO: 임시, 추후 API 요청에 throttle 혹은 debounce 추가
                do { try await Task.sleep(nanoseconds: 1_000_000_000) }
                catch { LoggingManager.error("Sleep Task was cancelled: \(error.localizedDescription)") }
                
                await self.store.send(.launch)
            }
            .onChange(of: self.store.state.isLaunched) { _, new in
                let hasTokens = TokenManager.shared.accessToken.isEmpty == false &&
                                TokenManager.shared.refreshToken.isEmpty == false
                // self.appCoordinator.currentState = hasTokens ? .mainTabBar: .signUp
                self.appCoordinator.currentState = .mainTabBar
            }
    }
}
