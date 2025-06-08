//
//  InitialMatchingViewModel.swift
//  OneThing
//
//  Created by 오현식 on 5/21/25.
//

import Foundation

@Observable
class InitialMatchingViewModel {
    
    struct State: Equatable {
        var selectedJobs: [JobType]
        var selectedDietaries: [DietaryType]
        var dietaryWithContents: String
        var selectedLanguages: [Language]
        var isSuccess: Bool
    }
    var currentState: State
    
    private let updateJobUseCase: UpdateJobUseCase
    private let updateDietaryUseCase: UpdateDietaryUseCase
    private let updateLanguageUseCase: UpdateLanguageUseCase
    
    init(
        updateJobUseCase: UpdateJobUseCase = UpdateJobUseCase(),
        updateDietaryUseCase: UpdateDietaryUseCase = UpdateDietaryUseCase(),
        updateLanguageUseCase: UpdateLanguageUseCase = UpdateLanguageUseCase()
    ) {
        self.currentState = .init(
            selectedJobs: [],
            selectedDietaries: [],
            dietaryWithContents: "",
            selectedLanguages: [],
            isSuccess: false
        )
        
        self.updateJobUseCase = updateJobUseCase
        self.updateDietaryUseCase = updateDietaryUseCase
        self.updateLanguageUseCase = updateLanguageUseCase
    }
    
    func initializeState(_ path: OTHomePath.InitialMatching) {
        switch path {
        case .job:
            self.currentState.selectedJobs = []
        case .dietary:
            self.currentState.selectedDietaries = []
            self.currentState.dietaryWithContents = ""
        case .language:
            self.currentState.selectedLanguages = []
        default:
            break
        }
    }
    
    func updateAll() async {
        do {
            async let isUpdateJobSuccess = self.updateJob()
            async let isUpdateDietarySuccess = self.updateDietary()
            async let isUpdateLanguageSuccess = self.updateLanguage()
            
            let isSuccess = try await [
                isUpdateJobSuccess,
                isUpdateDietarySuccess,
                isUpdateLanguageSuccess
            ]
            await MainActor.run {
                self.currentState.isSuccess = isSuccess.allSatisfy { $0 }
            }
        } catch {
            await MainActor.run {
                self.currentState.isSuccess = false
            }
        }
    }
}

extension InitialMatchingViewModel {
    
    private func updateJob() async throws -> Bool {
        do {
            guard let selectedJob = self.currentState.selectedJobs.last else { return false }
            
            return try await self.updateJobUseCase.execute(job: selectedJob)
        } catch {
            return false
        }
    }
    
    private func updateDietary() async throws -> Bool {
        do {
            guard let selectedDietary = self.currentState.selectedDietaries.last else { return false }
            var dietaryOption: String {
                switch selectedDietary {
                case .etc: return self.currentState.dietaryWithContents
                default: return selectedDietary.toKorean
                }
            }
            
            return try await self.updateDietaryUseCase.execute(dietaryOption: dietaryOption)
        } catch {
            return false
        }
    }
    
    private func updateLanguage() async throws -> Bool {
        do {
            guard let selectedLanguage = self.currentState.selectedLanguages.last else { return false }
            return try await self.updateLanguageUseCase.execute(language: selectedLanguage)
        } catch {
            return false
        }
    }
}
