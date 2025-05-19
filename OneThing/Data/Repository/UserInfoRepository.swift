//
//  UserInfoRepository.swift
//  OneThing
//
//  Created by 윤동주 on 5/3/25.
//

import Foundation

struct UserInfoRepository {
    private let networkService = OTNetworkService()
    
    // MARK: - GET
    
    func usersRelationship() async throws -> RelationshipDTO {
        let endpoint = EndPoint(
            path: "/users/relationship",
            method: .get,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await networkService.get(endpoint: endpoint)
    }
    
    func usersLanguage() async throws -> LanguageDTO {
        let endpoint = EndPoint(
            path: "/users/language",
            method: .get,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await networkService.get(endpoint: endpoint)
    }
    
    func usersJob() async throws -> JobDTO {
        let endpoint = EndPoint(
            path: "/users/job",
            method: .get,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await networkService.get(endpoint: endpoint)
    }
    
    func usersDietary() async throws -> DietaryDTO {
        let endpoint = EndPoint(
            path: "/users/dietary",
            method: .get,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await networkService.get(endpoint: endpoint)
    }
    
    func usersProfile() async throws -> UserProfileInfo {
        let endpoint = EndPoint(
            path: "/users/profile",
            method: .get,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        let dto: RetrieveUserProfileInfoDTO = try await networkService.get(endpoint: endpoint)

        return dto.toDomain()
    }
    
    // MARK: - POST
    
    /// Data는 빈 값
    func usersNicknameAvailable(with dto: UpdateNicknameDTO) async throws -> Bool {
        let endpoint = EndPoint(
            path: "/users/nickname/available",
            method: .post,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        do {
            return try await networkService.post(endpoint: endpoint, body: dto).statusCode == 200
        } catch let error as NetworkError {
            if case .invalidHttpStatusCode(let code) = error, code == 400 {
                return false
            } else {
                throw error
            }
        }
    }
    
    // MARK: - PATCH
    
    func usersRelationship(with dto: RelationshipDTO) async throws -> HTTPURLResponse {
        let endpoint = EndPoint(
            path: "/users/relationship",
            method: .patch,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await networkService.patch(endpoint: endpoint, body: dto)
    }
    
    func usersPhone(with dto: UpdatePhoneNumberDTO) async throws -> HTTPURLResponse {
        let endpoint = EndPoint(
            path: "/users/phone",
            method: .patch,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await networkService.patch(endpoint: endpoint, body: dto)
    }
    
    func usersNotify(with dto: UpdateNotifyAllowDTO) async throws -> HTTPURLResponse {
        let endpoint = EndPoint(
            path: "/users/notify",
            method: .patch,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await networkService.patch(endpoint: endpoint, body: dto)
    }
    
    func usersNickname(with dto: UpdateNicknameDTO) async throws -> HTTPURLResponse {
        let endpoint = EndPoint(
            path: "/users/nickname",
            method: .patch,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await networkService.patch(endpoint: endpoint, body: dto)
    }
    
    func usersName(with dto: UpdateNameDTO) async throws -> HTTPURLResponse {
        let endpoint = EndPoint(
            path: "/users/name",
            method: .patch,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await networkService.patch(endpoint: endpoint, body: dto)
    }
    
    func usersLanguage(with dto: LanguageDTO) async throws -> HTTPURLResponse {
        let endpoint = EndPoint(
            path: "/users/language",
            method: .patch,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await networkService.patch(endpoint: endpoint, body: dto)
    }
    
    func usersJob(with dto: JobDTO) async throws -> HTTPURLResponse {
        let endpoint = EndPoint(
            path: "/users/job",
            method: .patch,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await networkService.patch(endpoint: endpoint, body: dto)
    }
    
    func usersFCM(with dto: UpdateFCMDTO) async throws -> HTTPURLResponse {
        let endpoint = EndPoint(
            path: "/users/fcm",
            method: .patch,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await networkService.patch(endpoint: endpoint, body: dto)
    }
    
    func usersDietary(with dto: DietaryDTO) async throws -> HTTPURLResponse {
        let endpoint = EndPoint(
            path: "/users/dietary",
            method: .patch,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await networkService.patch(endpoint: endpoint, body: dto)
    }
    
    func usersDetail(with dto: UpdateUserDetailInfoDTO) async throws -> HTTPURLResponse {
        let endpoint = EndPoint(
            path: "/users/detail",
            method: .patch,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        return try await networkService.patch(endpoint: endpoint, body: dto)
    }
    
    func usersDetail(with dto: RetrieveUserProfileInfoDTO) async throws -> HTTPURLResponse {
        let endpoint = EndPoint(
            path: "/users/profile",
            method: .patch,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        return try await networkService.patch(endpoint: endpoint, body: dto)
    }
}
