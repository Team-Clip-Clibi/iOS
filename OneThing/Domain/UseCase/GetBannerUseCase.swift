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
    
    func execute(with bannerInfoType: BannerInfoType) async throws -> [BannerInfo] {
        return try await self.repository.banners(with: bannerInfoType).toDomain()
    }
    
    func execute(with bannerInfoType: BannerInfoType) async throws -> [Banner] {
        return try await self.repository.banners(with: bannerInfoType).toDomain()
    }
}
