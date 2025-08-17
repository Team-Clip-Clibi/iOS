//
//  LaunchScreenAssembler.swift
//  OneThing
//
//  Created by 오현식 on 8/2/25.
//

import Foundation

final class LaunchScreenAssembler: OTAssemblerable {
    
    func assemble(container: OTDIContainerable) {
        container.register(LaunchScreenStore.self) { resolver in
            LaunchScreenStore(
                sessionStore: resolver.resolve(SessionStoring.self),
                authRepository: resolver.resolve(AuthRepository.self),
                appStateManager: resolver.resolve(AppStateManager.self)
            )
        }
    }
}
