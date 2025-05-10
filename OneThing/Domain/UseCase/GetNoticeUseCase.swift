//
//  GetNoticeUseCase.swift
//  OneThing
//
//  Created by 오현식 on 5/9/25.
//

import Foundation

struct GetNoticeUseCase {
    private let repository: NotificationRepository
    
    init(repository: NotificationRepository = NotificationRepository()) {
        self.repository = repository
    }
    
    func execute() async throws -> [NoticeInfo] {
        return try await self.repository.notice().noticeInfos
    }
}
