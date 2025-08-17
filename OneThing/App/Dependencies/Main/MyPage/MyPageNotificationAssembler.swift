//
//  MyPageNotificationAssembler.swift
//  OneThing
//
//  Created by 오현식 on 8/10/25.
//

import Foundation

final class MyPageNotificationAssembler: OTAssemblerable {
    
    func assemble(container: OTDIContainerable) {
        container.register(UserInfoRepository.self) { _ in
            UserInfoRepository()
        }
        container.register(UpdateUserNotifyUseCase.self) { resolver in
            UpdateUserNotifyUseCase(repository: resolver.resolve(UserInfoRepository.self))
        }
        
        container.register(MyPageNotificationStore.self) { resolver in
            MyPageNotificationStore(updateUserNotifyUseCase: resolver.resolve(UpdateUserNotifyUseCase.self))
        }
    }
}
