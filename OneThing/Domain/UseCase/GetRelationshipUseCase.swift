//
//  GetRelationshipUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 5/4/25.
//


import Foundation

struct GetRelationshipUseCase {
    private let repository: UserInfoRepository
    
    init(repository: UserInfoRepository = UserInfoRepository()) {
        self.repository = repository
    }
    
    func execute() async throws -> RelationshipInfo {
        let result = try await repository.usersRelationship()

        return RelationshipInfo(
            status: result.relationshipStatus,
            isConsidered: result.isSameRelationshipConsidered
        )
    }
}
