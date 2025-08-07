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
    
    /// 연애 상태 변경 조회 API
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
    
    /// 사용 언어 조회 API
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
    
    /// 하는 일 조회 API
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
    
    /// 식단 제한 조회 API
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
    
    /// 프로필 기본 정보 조회 API
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
    
    /// 신청 모임 존재 여부 확인 API
    func usersMatchingsExists() async throws -> Bool {
        let endpoint = EndPoint(
            path: "/users/matchings/exists",
            method: .get,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenManager.shared.accessToken)"
            ]
        )
        
        return try await networkService.get(endpoint: endpoint)
    }
    
    // MARK: - POST
    
    /// 사용 가능한 닉네임 확인 API
    func usersNicknameAvailable(with dto: NicknameDTO) async throws -> Bool {
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
    
    /// 연애 상태 변경 API
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
    
    /// 번호 업데이트 API
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
    
    /// 알림 On/Off API
    func usersNotify(with dto: NotifyAllowDTO) async throws -> HTTPURLResponse {
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
    
    /// 닉네임 업데이트 API
    func usersNickname(with dto: NicknameDTO) async throws -> HTTPURLResponse {
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
    
    /// 이름 업데이트 API
    func usersName(with dto: UserNameDTO) async throws -> HTTPURLResponse {
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
    
    /// 사용 언어 변경 API
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
    
    /// 하는 일 변경 API
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
    
    /// FCM 업데이트 API
    func usersFCM(with dto: FCMTokenDTO) async throws -> HTTPURLResponse {
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
    
    /// 식단 제한 변경 API
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
    
    /// 유저 상세 정보 업데이트 API
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
}
