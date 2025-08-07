//
//  UpdateRelationshipUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 5/4/25.
//

import Foundation

struct UpdateRelationshipUseCase {
    private let repository: UserInfoRepository
    
    init(repository: UserInfoRepository = UserInfoRepository()) {
        self.repository = repository
    }
    
    func execute(status: RelationshipStatus, isSameRelationshipConsidered: Bool) async throws -> Bool {
        let statusCode = try await repository.usersRelationship(
            with: RelationshipDTO(
                relationshipStatus: status,
                isSameRelationshipConsidered: isSameRelationshipConsidered
            )
        ).statusCode
        return statusCode == 204
    }
}
