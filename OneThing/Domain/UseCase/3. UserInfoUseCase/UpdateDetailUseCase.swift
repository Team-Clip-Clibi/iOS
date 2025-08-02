//
//  UpdateDetailUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 7/27/25.
//

import Foundation

struct UpdateDetailUseCase {
    private let repository: UserInfoRepository
    
    init(repository: UserInfoRepository = UserInfoRepository()) {
        self.repository = repository
    }
    
    func execute(gender: String, birth: String, city: String, county: String) async throws -> Bool {
        let statusCode = try await repository.usersDetail(
            with: UpdateUserDetailInfoDTO(
                gender: gender,
                birth: birth,
                city: city,
                county: county
            )
        ).statusCode
        return statusCode == 204
    }
}
