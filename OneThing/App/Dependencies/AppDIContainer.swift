//
//  AppDIContainer.swift
//  OneThing
//
//  Created by 오현식 on 8/2/25.
//

import Foundation

/// 앱의 전체 DI 흐름을 관리하고, 각 화면 흐름에 맞는 자식 DI 컨테이너를 생성하는 역할을 합니다.
final class AppDIContainer {
    
    // 앱의 최상위(Root) 컨테이너. 공통 서비스들이 여기에 등록됩니다.
    let rootContainer: OTDIContainerable
    
    init() {
        self.rootContainer = OTDIContainer()
        
        // 앱 시작 시, 최상위 컨테이너에 공통 의존성을 등록합니다.
        let appAssembler = AppAssembler()
        appAssembler.assemble(container: self.rootContainer)
    }
    
    func setupLaunchScreenContainer() -> OTDIContainerable {
        let container = OTDIContainer(self.rootContainer)
        let assembler = LaunchScreenAssembler()
        assembler.assemble(container: container)
        return container
    }
}


// MARK: Sign UP

extension AppDIContainer {
    
    func setupSignUpContainer() -> OTDIContainerable {
        let container = OTDIContainer(self.rootContainer)
        let assembler = SignUpAssembler()
        assembler.assemble(container: container)
        return container
    }
}


// MARK: Home

extension AppDIContainer {
    
    func setupHomeCotainer() -> OTDIContainerable {
        let container = OTDIContainer(self.rootContainer)
        let assembler = HomeAssembler()
        assembler.assemble(container: container)
        return container
    }
    
    func setupNotificationContainer() -> OTDIContainerable {
        let container = OTDIContainer(self.rootContainer)
        let assembler = NotificationAssembler()
        assembler.assemble(container: container)
        return container
    }
    
    func setupInitialMatchingContainer(
        with willPushedMatchingType: MatchingType
    ) -> OTDIContainerable {
        let container = OTDIContainer(self.rootContainer)
        let assembler = InitialMatchingAssembler(with: willPushedMatchingType)
        assembler.assemble(container: container)
        return container
    }
    
    func setupOnethingMatchingContainer() -> OTDIContainerable {
        let container = OTDIContainer(self.rootContainer)
        let assembler = OnethingMatchingAssembler()
        assembler.assemble(container: container)
        return container
    }
    
    func setupRandomMatchingContainer(with nickname: String) -> OTDIContainer {
        let container = OTDIContainer(self.rootContainer)
        let assembler = RandomMatchingAssembler(with: nickname)
        assembler.assemble(container: container)
        return container
    }
    
    func setupInMeetingContatiner(
        with matchingId: String,
        type matchingType: MatchingType
    ) -> OTDIContainerable {
        let container = OTDIContainer(self.rootContainer)
        let assembler = InMeetingAssembler(with: matchingId, type: matchingType)
        assembler.assemble(container: container)
        return container
    }
    
    func setupMeetingReviewContainer(
        _ nicknames: [String],
        with matchingId: String,
        type matchingType: MatchingType
    ) -> OTDIContainer {
        let container = OTDIContainer(self.rootContainer)
        let assembler = MeetingReviewAssembler(nicknames, with: matchingId, type: matchingType)
        assembler.assemble(container: container)
        return container
    }
}


// MARK: My Page

extension AppDIContainer {
    
    func setupMyPageEditContainer() -> OTDIContainer {
        let container = OTDIContainer(self.rootContainer)
        let assembler = MyPageEditAssembler()
        assembler.assemble(container: container)
        return container
    }
    
    func setupMyPageNotificationContainer() -> OTDIContainer {
        let container = OTDIContainer(self.rootContainer)
        let assembler = MyPageNotificationAssembler()
        assembler.assemble(container: container)
        return container
    }
    
    func setupMyPageReportContainer() -> OTDIContainer {
        let container = OTDIContainer(self.rootContainer)
        let assembler = MyPageReportAssembler()
        assembler.assemble(container: container)
        return container
    }
}
