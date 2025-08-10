//
//  AppCoordinator.swift
//  OneThing
//
//  Created by 오현식 on 8/2/25.
//

import SwiftUI

@Observable
final class AppCoordinator: OTBaseCoordinator {
    
    enum AppState {
        case launch
        case signUp
        case mainTabBar
    }

    private var launchScreenStore: LaunchScreenStore
    private var launchScreenStoreForBinding: Binding<LaunchScreenStore> {
        Binding(
            get: { self.launchScreenStore },
            set: { self.launchScreenStore = $0 }
        )
    }
    
    var dependencies: AppDIContainer
    
    var currentState: AppState = .launch
    
    init(dependencies: AppDIContainer) {
        self.dependencies = dependencies
        
        let launchScreenStore = dependencies.setupLaunchScreenContainer().resolve(
            LaunchScreenStore.self
        )
        self.launchScreenStore = launchScreenStore
        
        super.init(rootViewBuilder: LaunchScreenViewBuilder())
    }
}

extension AppCoordinator {
    
    func presentLaunch() -> LaunchScreenView {
        (self.rootViewBuilder as! LaunchScreenViewBuilder).build(store: self.launchScreenStoreForBinding)
    }
    
    func presentSignUp() -> SignUpMainView {
        self.childCoordinator.removeAll()
        
        let signUpCoordinator = SignUpCoordinator(dependencies: self.dependencies)
        self.addChild(signUpCoordinator)
        return signUpCoordinator.start()
    }
    
    func presentMainTabbar() -> MainTabBarView {
        self.childCoordinator.removeAll()
        
        let mainTabBarCoordinator = MainTabBarCoordinator(
            dependencies: self.dependencies,
            initialTab: 0,
            initialType: .onething
        )
        self.addChild(mainTabBarCoordinator)
        return mainTabBarCoordinator.start()
    }
}

private struct AppCoordinatorKey: EnvironmentKey {
    // static var defaultValue: AppCoordinator {
    //     fatalError("FatalError: AppCoordinator not set in environment")
    // }
    static var defaultValue: AppCoordinator = AppCoordinator(dependencies: AppDIContainer())
}

extension EnvironmentValues {
    var appCoordinator: AppCoordinator {
        get { self[AppCoordinatorKey.self] }
        set { self[AppCoordinatorKey.self] = newValue }
    }
}
