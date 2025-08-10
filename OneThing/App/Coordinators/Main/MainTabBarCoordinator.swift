//
//  MainTabBarCoordinator.swift
//  OneThing
//
//  Created by 오현식 on 8/2/25.
//

import SwiftUI

@Observable
final class MainTabBarCoordinator: OTBaseCoordinator {

    var dependencies: AppDIContainer
    
    var currentTab: Int
    var willPushedMatchingType: MatchingType
    
    init(
        dependencies: AppDIContainer,
        initialTab currentTab: Int,
        initialType willPushedMatchingType: MatchingType
    ) {
        self.dependencies = dependencies
        
        self.currentTab = currentTab
        self.willPushedMatchingType = willPushedMatchingType
        
        super.init(rootViewBuilder: MainTabBarViewBuilder())
    }
    
    func start() -> MainTabBarView {
        if let signUpCoordinator = self.childCoordinator.first(
            where: { $0 is SignUpCoordinator }
        ) as? SignUpCoordinator {
            
            self.removeChild(signUpCoordinator)
        }
        
        let homeCoordinator = HomeCoordinator(
            dependencies: self.dependencies,
            initialType: self.willPushedMatchingType
        )
        self.addChild(homeCoordinator)
        
        let myPageCoordinator = MyPageCoordinator(dependencies: self.dependencies)
        self.addChild(myPageCoordinator)
        
        return (self.rootViewBuilder as! MainTabBarViewBuilder).build()
    }
}
