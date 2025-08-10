//
//  InitialMatchingStore.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import Foundation

@Observable
class InitialMatchingStore: OTStore {
    
    enum Action: OTAction {
        case updateSelectedJob(JobType?)
        case updateSelectedDietary(DietaryType?)
        case updateDietaryWithContents(String?)
        case updateSelectedLanguages(Language?)
        case updateAll
    }
    
    enum Process: OTProcess {
        case updateSelectedJob(JobType?)
        case updateSelectedDietary(DietaryType?)
        case updateDietaryWithContents(String?)
        case updateSelectedLanguages(Language?)
        case updateIsUpdated(Bool)
    }
    
    struct State: OTState {
        fileprivate(set) var selectedJob: JobType?
        fileprivate(set) var selectedDietary: DietaryType?
        fileprivate(set) var dietaryWithContents: String?
        fileprivate(set) var selectedLanguage: Language?
        fileprivate(set) var isUpdated: Bool
    }
    var state: State
    
    private let willPushedMatchingType: MatchingType
    
    private let updateJobUseCase: UpdateJobUseCase
    private let updateDietaryUseCase: UpdateDietaryUseCase
    private let updateLanguageUseCase: UpdateLanguageUseCase
    
    init(
        willPushedMatchingType: MatchingType,
        updateJobUseCase: UpdateJobUseCase,
        updateDietaryUseCase: UpdateDietaryUseCase,
        updateLanguageUseCase: UpdateLanguageUseCase
    ) {
        
        self.state = State(
            selectedJob: nil,
            selectedDietary: nil,
            dietaryWithContents: nil,
            selectedLanguage: nil,
            isUpdated: false
        )
        
        self.willPushedMatchingType = willPushedMatchingType
        
        self.updateJobUseCase = updateJobUseCase
        self.updateDietaryUseCase = updateDietaryUseCase
        self.updateLanguageUseCase = updateLanguageUseCase
    }
    
    func process(_ action: Action) async -> OTProcessResult<Process> {
        switch action {
        case let .updateSelectedJob(job):
            return await self.updateJob(job)
        case let .updateSelectedDietary(dietary):
            return await self.updateDietary(dietary)
        case let .updateDietaryWithContents(dietaryWithContents):
            return await self.updateDietaryWithContetns(dietaryWithContents)
        case let .updateSelectedLanguages(language):
            return await self.updateLanguage(language)
        case .updateAll:
            return await self.updateAll()
        }
    }
    
    func reduce(state: State, process: Process) -> State {
        var newState = state
        switch process {
        case let .updateSelectedJob(job):
            newState.selectedJob = job
        case let .updateSelectedDietary(dietary):
            newState.selectedDietary = dietary
        case let .updateDietaryWithContents(dietaryWithContents):
            newState.dietaryWithContents = dietaryWithContents
        case let .updateSelectedLanguages(language):
            newState.selectedLanguage = language
        case let .updateIsUpdated(isUpdated):
            newState.isUpdated = isUpdated
        }
        return newState
    }
}

private extension InitialMatchingStore {
    
    func updateJob(_ job: JobType?) async -> OTProcessResult<Process> {
        return .single(.updateSelectedJob(job))
    }
    
    func updateDietary(_ dietary: DietaryType?) async -> OTProcessResult<Process> {
        return .single(.updateSelectedDietary(dietary))
    }
    
    func updateDietaryWithContetns(
        _ dietaryWithContents: String?
    ) async -> OTProcessResult<Process> {
        return .single(.updateDietaryWithContents(dietaryWithContents))
    }
    
    func updateLanguage(_ language: Language?) async -> OTProcessResult<Process> {
        return .single(.updateSelectedLanguages(language))
    }
    
    func updateAll() async -> OTProcessResult<Process> {
        
        do {
            guard let selectedJob = self.state.selectedJob,
                  let selectedDietary = self.state.selectedDietary,
                  let selectedLanguage = self.state.selectedLanguage
            else { return .none }
            
            let isUpdatedJob = try await self.updateJobUseCase.execute(job: selectedJob)
            var dietaryOption: String {
                switch selectedDietary {
                case .etc:  return self.state.dietaryWithContents ?? ""
                default:    return selectedDietary.toKorean
                }
            }
            let isUpdatedDietary = try await self.updateDietaryUseCase.execute(
                dietaryOption: dietaryOption
            )
            let isUpdatedLanguage = try await self.updateLanguageUseCase.execute(
                language: selectedLanguage
            )
            
            return .single(.updateIsUpdated(isUpdatedJob && isUpdatedDietary && isUpdatedLanguage))
        } catch {
            return .single(.updateIsUpdated(false))
        }
    }
}
