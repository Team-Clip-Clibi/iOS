//
//  MyPageEditStore.swift
//  OneThing
//
//  Created by 오현식 on 8/9/25.
//

import Foundation

@Observable
class MyPageEditStore: OTStore {
    
    enum Action: OTAction {
        case deleteAccount
        case profile
        case job
        case relationship
        case dietary
        case language
        case checkNicknameAvailable(String)
        case updateNickname(String)
        case updateJob(JobType?)
        case updateRelationship(RelationshipStatus?, Bool)
        case updateDietary(String, String)
        case updateLanguage(Language?)
    }
    
    enum Process: OTProcess {
        case deleteAccount(Bool)
        case profile(UserProfileInfo?)
        case job(JobType?)
        case relationship(RelationshipInfo?)
        case dietary(String)
        case otherText(String)
        case language(Language?)
        case updateNicknameValid(Bool)
        case updateNickname(Bool)
        case updateJob(Bool)
        case updateRelationship(Bool)
        case updateDietary(Bool)
        case updateLanguage(Bool)
    }
    
    struct State: OTState {
        fileprivate(set) var profileInfo: UserProfileInfo?
        fileprivate(set) var job: JobType?
        fileprivate(set) var relationship: RelationshipInfo?
        fileprivate(set) var language: Language?
        fileprivate(set) var dietary: String
        fileprivate(set) var otherText: String
        fileprivate(set) var isAccountDeleted: Bool
        fileprivate(set) var isNicknameAvailable: Bool
        fileprivate(set) var isNicknameUpdated: Bool
        fileprivate(set) var isJobUpdated: Bool
        fileprivate(set) var isRelationshipUpdated: Bool
        fileprivate(set) var isDietaryUpdated: Bool
        fileprivate(set) var isLanguageUpdated: Bool
    }
    var state: State
    
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
    
    init(
        socialLoginUseCase: SocialLoginUseCase,
        
        getProfileInfoUseCase: GetProfileInfoUseCase,
        getJobUseCase: GetJobUseCase,
        getRelationshipUseCase: GetRelationshipUseCase,
        getDietaryUseCase: GetDietaryUseCase,
        getLanguageUseCase: GetLanguageUseCase,
        getNicknameAvailableUseCase: GetNicknameAvailableUseCase,
        
        updateNicknameUseCase: UpdateNicknameUseCase,
        updateJobUseCase: UpdateJobUseCase,
        updateRelationshipUseCase: UpdateRelationshipUseCase,
        updateDietaryUseCase: UpdateDietaryUseCase,
        updateLanguageUseCase: UpdateLanguageUseCase
    ) {
        
        self.state = State(
            profileInfo: nil,
            job: nil,
            relationship: nil,
            language: nil,
            dietary: "",
            otherText: "",
            isAccountDeleted: false,
            isNicknameAvailable: false,
            isNicknameUpdated: false,
            isJobUpdated: false,
            isRelationshipUpdated: false,
            isDietaryUpdated: false,
            isLanguageUpdated: false
        )
        
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
    
    func process(_ action: Action) async -> OTProcessResult<Process> {
        switch action {
        case .deleteAccount:
            return await self.deleteAccount()
        case .profile:
            return await self.profile()
        case .job:
            return await self.job()
        case .relationship:
            return await self.relationship()
        case .dietary:
            return await self.dietary()
        case .language:
            return await self.language()
        case let .checkNicknameAvailable(nickname):
            return await self.isNickNameAvailable(nickname)
        case let .updateNickname(nickname):
            return await self.updateNickname(nickname)
        case let .updateJob(job):
            return await self.updateJob(job)
        case let .updateRelationship(status, isConsidered):
            return await self.updateRelationship(status, isConsidered: isConsidered)
        case let .updateDietary(dietary, otherText):
            return await self.updateDietary(dietary, with: otherText)
        case let .updateLanguage(language):
            return await self.updateLanguage(language)
        }
    }
    
    func reduce(state: State, process: Process) -> State {
        var newState = state
        switch process {
        case let .deleteAccount(isAccountDeleted):
            newState.isAccountDeleted = isAccountDeleted
        case let .profile(profileInfo):
            newState.profileInfo = profileInfo
        case let .job(job):
            newState.job = job
        case let .relationship(relationship):
            newState.relationship = relationship
        case let .dietary(dietary):
            newState.dietary = dietary
        case let .otherText(otherText):
            newState.otherText = otherText
        case let .language(language):
            newState.language = language
        case let .updateNicknameValid(isNicknameAvailable):
            newState.isNicknameAvailable = isNicknameAvailable
        case let .updateNickname(isNicknameUpdated):
            newState.isNicknameUpdated = isNicknameUpdated
        case let .updateJob(isJobUpdated):
            newState.isJobUpdated = isJobUpdated
        case let .updateRelationship(isRelationshipUpdated):
            newState.isRelationshipUpdated = isRelationshipUpdated
        case let .updateDietary(isDietaryUpdated):
            newState.isDietaryUpdated = isDietaryUpdated
        case let .updateLanguage(isLanguageUpdated):
            newState.isLanguageUpdated = isLanguageUpdated
        }
        return newState
    }
}

private extension MyPageEditStore {
    
    func deleteAccount() async -> OTProcessResult<Process> {
        
        do {
            let isDeleted = try await self.socialLoginUseCase.deleteAccount()
            
            return .single(.deleteAccount(isDeleted))
        } catch {
            return .single(.deleteAccount(false))
        }
    }
    
    func profile() async -> OTProcessResult<Process> {
        
        do {
            let profileInfo = try await self.getProfileInfoUseCase.execute()
            
            return .single(.profile(profileInfo))
        } catch {
            
            return .single(.profile(nil))
        }
    }
    
    func job() async -> OTProcessResult<Process> {
        
        do {
            let job = try await self.getJobUseCase.execute()
            
            return .single(.job(job))
        } catch {
            return .single(.job(nil))
        }
    }
    
    func relationship() async -> OTProcessResult<Process> {
        
        do {
            let relationship = try await self.getRelationshipUseCase.execute()
            
            return .single(.relationship(relationship))
        } catch {
            return .single(.relationship(nil))
        }
    }
    
    func dietary() async -> OTProcessResult<Process> {
        
        do {
            let result = try await self.getDietaryUseCase.execute()
            if result.isEmpty {
                return .concat([
                    .dietary(""),
                    .otherText("")
                ])
            } else if result != "비건이에요" &&
                    result != "베지테리언이에요" &&
                    result != "글루텐프리를 지켜요" &&
                    result != "다 잘먹어요" {
                return .concat([
                    .dietary("기타"),
                    .otherText(result)
                ])
            } else {
                return .single(.dietary(result))
            }
        } catch {
            return .concat([
                .dietary(""),
                .otherText("")
            ])
        }
    }
    
    func language() async -> OTProcessResult<Process> {
        
        do {
            let language = try await self.getLanguageUseCase.execute()
            
            return .single(.language(language))
        } catch {
            return .single(.language(nil))
        }
    }
    
    func isNickNameAvailable(_ nickname: String) async -> OTProcessResult<Process> {
        
        do {
            let isNickNameAvailable = try await self.getNicknameAvailableUseCase.execute(
                with: nickname
            )
            
            return .single(.updateNicknameValid(isNickNameAvailable))
        } catch {
            return .single(.updateNicknameValid(false))
        }
    }
    
    func updateNickname(_ nickname: String) async -> OTProcessResult<Process> {
        
        do {
            let isNicknameUpdated = try await self.updateNicknameUseCase.execute(
                nickname: nickname
            )
            
            return .single(.updateNickname(isNicknameUpdated))
        } catch {
            return .single(.updateNickname(false))
        }
    }
    
    func updateJob(_ job: JobType?) async -> OTProcessResult<Process> {
        
        do {
            guard let job = job else { return .single(.updateJob(false)) }
            
            let isJobUpdated = try await self.updateJobUseCase.execute(job: job)
            
            return .single(.updateJob(isJobUpdated))
        } catch {
            return .single(.updateJob(false))
        }
    }
    
    func updateRelationship(_ status: RelationshipStatus?, isConsidered: Bool) async -> OTProcessResult<Process> {
        
        do {
            guard let status = status else { return .single(.updateRelationship(false)) }
            
            let isRelationshipUpdated = try await self.updateRelationshipUseCase.execute(
                status: status,
                isSameRelationshipConsidered: isConsidered
            )
            
            return .single(.updateRelationship(isRelationshipUpdated))
        } catch {
            return .single(.updateRelationship(false))
        }
    }
    
    func updateDietary(_ dietary: String, with otherText: String) async -> OTProcessResult<Process> {
        
        do {
            
            let isDietaryUpdated = try await self.updateDietaryUseCase.execute(
                dietaryOption: dietary == "기타" ? otherText: dietary
            )
         
            return .single(.updateDietary(isDietaryUpdated))
        } catch {
            return .single(.updateDietary(false))
        }
    }
    
    func updateLanguage(_ language: Language?) async -> OTProcessResult<Process> {
        
        do {
            guard let language = language else { return .single(.updateLanguage(false)) }
            
            let isLanguageUpdated = try await self.updateLanguageUseCase.execute(language: language)
            
            return .single(.updateLanguage(isLanguageUpdated))
        } catch {
            return .single(.updateLanguage(false))
        }
    }
}
