//
//  MeetingReviewViewModel.swift
//  OneThing
//
//  Created by 오현식 on 6/10/25.
//

import SwiftUI

@Observable
class MeetingReviewViewModel {
    
    struct InitialInfo: Equatable, Hashable {
        let nicknames: [String]
        let matchingId: String
        let matchingtype: MatchingType
    }
    
    struct State: Equatable {
        fileprivate(set) var selectedMood: MeetingReviewMood?
        fileprivate(set) var selectedPositivePoints: [String]
        fileprivate(set) var selectedNegativePoints: [String]
        fileprivate(set) var reviewContent: String
        fileprivate(set) var attendee: AttendeesInfo?
        fileprivate(set) var noShowMembers: [String]
        fileprivate(set) var isSuccess: Bool
    }
    var currentState: State
    
    let positivePotintsContents = [
        "대화가 흥미로웠어요",
        "멤버들이 적극적으로 참여했어요",
        "진행이 매끄러웠어요",
        "분위기가 편안하고 즐거웠어요",
        "시간과 장소가 적절했어요"
    ]
    let negativePointsContents = [
        "대화가 지루했어요",
        "멤버들이 소극적이었어요",
        "진행이 이해하기 어려웠어요",
        "분위기가 어색하거나 불편했어요",
        "시간과 장소가 마음에 안들어요",
        "약속 시간을 지키지 않은 멤버가 많았어요"
    ]
    
    let submitMeetingReviewUseCase: SubmitMeetingReviewUseCase
    let initalInfo: InitialInfo
    
    init(
        submitMeetingReviewUseCase: SubmitMeetingReviewUseCase = SubmitMeetingReviewUseCase(),
        initalInfo: InitialInfo
    ) {
        
        self.currentState = .init(
            selectedMood: nil,
            selectedPositivePoints: [],
            selectedNegativePoints: [],
            reviewContent: "",
            attendee: nil,
            noShowMembers: [],
            isSuccess: false
        )
        
        self.submitMeetingReviewUseCase = submitMeetingReviewUseCase
        self.initalInfo = initalInfo
    }
    
    func selectMood(_ mood: MeetingReviewMood) async {
        
        await MainActor.run {
            self.currentState.selectedMood = mood
        }
    }
    
    func selectPositivePoint(_ content: [String]) async {
        
        await MainActor.run {
            self.currentState.selectedPositivePoints = content
        }
    }
    
    func selectNegativePoint(_ content: [String]) async {
        
        await MainActor.run {
            self.currentState.selectedNegativePoints = content
        }
    }
    
    func reviewContent(_ content: String) async {
        
        await MainActor.run {
            self.currentState.reviewContent = content
        }
    }
    
    func selectAttendee(_ attendee: AttendeesInfo) async {
        
        await MainActor.run {
            self.currentState.attendee = attendee
        }
    }
    
    func selectNoShowMembers(_ members: [String]) async {
        
        await MainActor.run {
            self.currentState.noShowMembers = members
        }
    }
    
    func submit() async {
        
        guard let mood = self.currentState.selectedMood else { return }
        
        do {
            let isSuccess = try await self.submitMeetingReviewUseCase.execute(
                mood: mood,
                positivePoints: self.currentState.selectedPositivePoints.joined(separator: ", "),
                negativePoints: self.currentState.selectedNegativePoints.joined(separator: ", "),
                reviewContent: self.currentState.reviewContent,
                noShowMembers: self.currentState.noShowMembers.joined(separator: ", "),
                isMemberAllAttended: self.currentState.attendee == .all,
                matchingId: self.initalInfo.matchingId,
                matchingType: self.initalInfo.matchingtype
            )
            
            await MainActor.run {
                self.currentState.isSuccess = isSuccess
            }
        } catch {
            
            await MainActor.run {
                self.currentState.isSuccess = false
            }
        }
    }
}
