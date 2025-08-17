//
//  HomeAssembler.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import Foundation

final class HomeAssembler: OTAssemblerable {
    
    func assemble(container: OTDIContainerable) {
        container.register(UserInfoRepository.self) { _ in
            UserInfoRepository()
        }
        container.register(GetProfileInfoUseCase.self) { resolver in
            GetProfileInfoUseCase(repository: resolver.resolve(UserInfoRepository.self))
        }
        
        container.register(NotificationRepository.self) { _ in
            NotificationRepository()
        }
        container.register(GetUnReadNotificationUseCase.self) { resolver in
            GetUnReadNotificationUseCase(repository: resolver.resolve(NotificationRepository.self))
        }
        container.register(GetNotificationBannerUseCase.self) { resolver in
            GetNotificationBannerUseCase(repository: resolver.resolve(NotificationRepository.self))
        }
        container.register(UpdateNotificationBannerUseCase.self) { resolver in
            UpdateNotificationBannerUseCase(repository: resolver.resolve(NotificationRepository.self))
        }
        
        container.register(DisplayContentsRepository.self) { _ in
            DisplayContentsRepository()
        }
        container.register(GetNoticeUseCase.self) { resolver in
            GetNoticeUseCase(repository: resolver.resolve(DisplayContentsRepository.self))
        }
        container.register(GetBannerUseCase.self) { resolver in
            GetBannerUseCase(repository: resolver.resolve(DisplayContentsRepository.self))
        }
        
        container.register(MatchingManagementRepository.self) { _ in
            MatchingManagementRepository()
        }
        container.register(GetMatchingStatusUseCase.self) { resolver in
            GetMatchingStatusUseCase(repository: resolver.resolve(MatchingManagementRepository.self))
        }
        container.register(GetMatchingsUseCase.self) { resolver in
            GetMatchingsUseCase(repository: resolver.resolve(MatchingManagementRepository.self))
        }
        
        container.register(HomeStore.self) { resolver in
            HomeStore(
                getProfileUseCase: resolver.resolve(GetProfileInfoUseCase.self),
                getUnReadNotificationUseCase: resolver.resolve(GetUnReadNotificationUseCase.self),
                getNotificationBannerUseCase: resolver.resolve(GetNotificationBannerUseCase.self),
                updateNotificationBannerUseCase: resolver.resolve(UpdateNotificationBannerUseCase.self),
                noticeUseCase: resolver.resolve(GetNoticeUseCase.self),
                getMatchingStatusUseCase: resolver.resolve(GetMatchingStatusUseCase.self),
                getMatchingsUseCase: resolver.resolve(GetMatchingsUseCase.self),
                bannerUseCase: resolver.resolve(GetBannerUseCase.self)
            )
        }
    }
}
