//
//  MyPageEditViewModel.swift
//  OneThing
//
//  Created by 윤동주 on 4/21/25.
//

import Foundation

@Observable
class MyPageEditViewModel {
    
    // MARK: - Properties
    
    var profileInfo: UserProfileInfo?
    var job: JobType?
    var relationship: RelationshipInfo?
    
    var dietary: String = ""
    var otherText: String = ""
    
    var language: Language?
    
    private var socialLoginUseCase: SocialLoginUseCase
    private var getProfileInfoUseCase: GetProfileInfoUseCase
    private var getJobUseCase: GetJobUseCase
    private var getRelationshipUseCase: GetRelationshipUseCase
    private var getDietaryUseCase: GetDietaryUseCase
    private var getLanguageUseCase: GetLanguageUseCase
    private var getNicknameAvailableUseCase: GetNicknameAvailableUseCase
    private var updateNicknameUseCase: UpdateNicknameUseCase
    private var updateJobUseCase: UpdateJobUseCase
    private var updateRelationshipUseCase: UpdateRelationshipUseCase
    private var updateDietaryUseCase: UpdateDietaryUseCase
    private var updateLanguageUseCase: UpdateLanguageUseCase
    
    // MARK: - Initializer
    
    init(
        socialLoginUseCase: SocialLoginUseCase = SocialLoginUseCase(),
        
        getJobUseCase: GetJobUseCase = GetJobUseCase(),
        getProfileInfoUseCase: GetProfileInfoUseCase = GetProfileInfoUseCase(),
        getRelationshipUseCase: GetRelationshipUseCase = GetRelationshipUseCase(),
        getDietaryUseCase: GetDietaryUseCase = GetDietaryUseCase(),
        getLanguageUseCase: GetLanguageUseCase = GetLanguageUseCase(),
        getNicknameAvailableUseCase: GetNicknameAvailableUseCase = GetNicknameAvailableUseCase(),
        
        updateNicknameUseCase: UpdateNicknameUseCase = UpdateNicknameUseCase(),
        updateJobUseCase: UpdateJobUseCase = UpdateJobUseCase(),
        updateRelationshipUseCase: UpdateRelationshipUseCase = UpdateRelationshipUseCase(),
        updateDietaryUseCase: UpdateDietaryUseCase = UpdateDietaryUseCase(),
        updateLanguageUseCase: UpdateLanguageUseCase = UpdateLanguageUseCase()
    ) {
        self.socialLoginUseCase = socialLoginUseCase
        
        self.getJobUseCase = getJobUseCase
        self.getProfileInfoUseCase = getProfileInfoUseCase
        self.getRelationshipUseCase = getRelationshipUseCase
        self.getDietaryUseCase = getDietaryUseCase
        self.getLanguageUseCase = getLanguageUseCase
        self.getNicknameAvailableUseCase = getNicknameAvailableUseCase
        
        self.updateNicknameUseCase = updateNicknameUseCase
        self.updateJobUseCase = updateJobUseCase
        self.updateRelationshipUseCase = updateRelationshipUseCase
        self.updateDietaryUseCase = updateDietaryUseCase
        self.updateLanguageUseCase = updateLanguageUseCase
    }
    
    // MARK: - Functions
    
    func deleteAccount() async throws -> Bool {
        return try await socialLoginUseCase.deleteAccount()
    }
    
    @MainActor
    func fetchProfile() async throws {
        self.profileInfo = try await getProfileInfoUseCase.execute()
    }
    
    @MainActor
    func fetchJob() async throws {
        self.job = try await getJobUseCase.execute()
    }
    
    @MainActor
    func fetchRelationship() async throws {
        self.relationship = try await getRelationshipUseCase.execute()
    }
    
    @MainActor
    func fetchDietary() async throws {
        let result = try await getDietaryUseCase.execute()
        if result == "" {
            self.dietary = ""
            self.otherText = ""
        } else if result != "비건이에요" && result != "베지테리언이에요" && result != "글루텐프리를 지켜요" && result != "다 잘먹어요" {
            self.dietary = "기타"
            self.otherText = result
        } else {
            self.dietary = try await getDietaryUseCase.execute()
        }
    }
    
    @MainActor
    func fetchLanguage() async throws {
        self.language = try await getLanguageUseCase.execute()
    }
    
    func isNicknameAvailable(nickname: String) async throws -> Bool {
        return try await getNicknameAvailableUseCase.execute(with: nickname)
    }
    
    func updateNickname(nickname: String) async throws -> Bool {
        return try await updateNicknameUseCase.execute(nickname: nickname)
    }
    
    func updateJob() async throws -> Bool {
        guard let job = job else {
            throw NetworkError.invalidRequestData
        }
        return try await updateJobUseCase.execute(job: job)
    }
    
    func updateRelationship() async throws -> Bool {
        guard let status = relationship?.status, let isConsidered = relationship?.isConsidered else {
            throw UpdateError.noRelationshipInfo
        }
        return try await updateRelationshipUseCase.execute(status: status, isSameRelationshipConsidered: isConsidered)
    }
    
    func updateDietary() async throws -> Bool {
        if dietary == "기타" {
            return try await updateDietaryUseCase.execute(dietaryOption: otherText)
        } else {
            return try await updateDietaryUseCase.execute(dietaryOption: dietary)
        }
    }
    
    func updateLanguage() async throws -> Bool {
        guard let language = language else {
            return false
        }
        return try await updateLanguageUseCase.execute(language: language)
    }
}
