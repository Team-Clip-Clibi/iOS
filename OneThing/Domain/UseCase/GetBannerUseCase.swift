//
//  GetBannerUseCase.swift
//  OneThing
//
//  Created by 오현식 on 5/10/25.
//

import Foundation

struct GetBannerUseCase {
    private let repository: DisplayContentsRepository
    
    init(repository: DisplayContentsRepository = DisplayContentsRepository()) {
        self.repository = repository
    }
    
    func execute(with bannerType: BannerType) async throws -> [BannerInfo] {
        return try await self.repository.banners(with: bannerType).toDomain()
    }
}
