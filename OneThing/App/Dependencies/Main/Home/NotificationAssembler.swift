//
//  NotificationAssembler.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import Foundation

final class NotificationAssembler: OTAssemblerable {
    
    func assemble(container: OTDIContainerable) {
        container.register(NotificationRepository.self) { _ in
            NotificationRepository()
        }
        container.register(GetUnReadNotificationUseCase.self) { resolver in
            GetUnReadNotificationUseCase(repository: resolver.resolve(NotificationRepository.self))
        }
        container.register(GetReadNotificationUseCase.self) { resolver in
            GetReadNotificationUseCase(repository: resolver.resolve(NotificationRepository.self))
        }
        
        container.register(NotificationStore.self) { resolver in
            NotificationStore(
                unReadNotificationUseCase: resolver.resolve(GetUnReadNotificationUseCase.self),
                readNotificationUseCase: resolver.resolve(GetReadNotificationUseCase.self)
            )
        }
    }
}
