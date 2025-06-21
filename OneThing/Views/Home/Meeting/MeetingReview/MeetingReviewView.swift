//
//  AfterMeetingView.swift
//  OneThing
//
//  Created by 오현식 on 6/9/25.
//

import SwiftUI

struct MeetingReviewView: View {
    
    enum Constants {
        enum Text {
            static let naviTitle: String = "모임 후기"
            
            static let positivePointsTopTitle: String = "어떤 점이 좋았나요?"
            static let positivePointsBottomTitle: String = "좋았던 점도 있다면 알려주세요"
            
            static let negativePointsTopTitle: String = "어떤 점이 아쉬웠나요?"
            static let negativePointsBottomTitle: String = "아쉬운 점이 있다면 알려주세요"
            
            static let completeButtonTitle: String = "완료"
        }
    }
    
    @Binding var appPathManager: OTAppPathManager
    @Binding var viewModel: MeetingReviewViewModel
    
    @State private var isReviewSelected: Bool = false
    @State private var selectedReview: [MeetingReviewInfo] = []
    @State private var isMeetingWasPositive: Bool = false
    
    @State private var isPositivePointsSelected: Bool = false
    @State private var selectedPositivePoints: [String] = []
    @State private var isNegativePointsSelected: Bool = false
    @State private var selectedNegativePoints: [String] = []
    
    @State private var reviewContent: String = ""
    
    @State private var isAttendeesSelected: Bool = false
    @State private var selectedAttendees: [AttendeesInfo] = []
    @State private var isNoShowMembersSelected: Bool = false
    @State private var selectedNoShowMembers: [String] = []
    
    @State private var isCompleteButtonEnabled: Bool = false
    
    var body: some View {
        
        VStack {
            
            NavigationBar()
                .title(Constants.Text.naviTitle)
                .hidesBottomSeparator(false)
                .onBackButtonTap { self.appPathManager.pop() }
            
            
            // MARK: Top Title Text
            
            Spacer().frame(height: 16)
            
            MeetingReviewGuideMeesageView(isReviewSelected: $isReviewSelected)
            
            
            // MARK: Meeting Review Point
            
            Spacer().frame(height: 32)
            
            MultipleTextWithImageBoxView<MeetingReviewInfo>(
                viewType: .meeting,
                matrixs: [GridItem()],
                state: .init(
                    items: MeetingReviewInfo.allCases.map { .init(item: $0) },
                    selectLimit: 1
                ),
                isReachedLimit: .constant(false),
                isSelected: $isReviewSelected,
                selectedItems: $selectedReview
            )
            .onChange(of: self.selectedReview) { old, new in
                guard let selectedReview = new.last else { return }
                
                switch selectedReview {
                case .disappointed, .unsatisfied:
                    self.isMeetingWasPositive = false
                case .neutral, .good, .excellent:
                    self.isMeetingWasPositive = true
                }
                
                if old.last != selectedReview {
                    Task {
                        await self.viewModel.selectMood(selectedReview)
                    }
                }
            }
            .onChange(of: self.isReviewSelected) { old, new in
                if old != new { self.updateCompleteButtonEnabled() }
            }
            
            
            // MARK: Selected Meeting Reivew Reason
            
            if self.isReviewSelected {
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    Spacer().frame(height: 24)
                    
                    Rectangle()
                        .fill(.gray200)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        .frame(height: 1)
                    
                    Spacer().frame(height: 40)
                    
                    VStack(spacing: 32) {
                        
                        if self.isMeetingWasPositive {
                            
                            PositivePointsView(
                                title: Constants.Text.positivePointsTopTitle,
                                messages: self.viewModel.positivePotintsContents,
                                isSelected: $isPositivePointsSelected,
                                positivePoints: $selectedPositivePoints
                            )
                        } else {
                            
                            NegativePointsView(
                                title: Constants.Text.negativePointsTopTitle,
                                messages: self.viewModel.negativePointsContents,
                                isSelected: $isNegativePointsSelected,
                                nagativePoints: $selectedNegativePoints
                            )
                        }
                        
                        if self.isMeetingWasPositive {
                            
                            NegativePointsView(
                                title: Constants.Text.negativePointsBottomTitle,
                                messages: self.viewModel.negativePointsContents,
                                isSelected: $isNegativePointsSelected,
                                nagativePoints: $selectedNegativePoints
                            )
                        } else {
                            
                            PositivePointsView(
                                title: Constants.Text.positivePointsBottomTitle,
                                messages: self.viewModel.positivePotintsContents,
                                isSelected: $isPositivePointsSelected,
                                positivePoints: $selectedPositivePoints
                            )
                        }
                    }
                    .onChange(of: self.isPositivePointsSelected) { old, new in
                        if old != new { self.updateCompleteButtonEnabled() }
                    }
                    .onChange(of: self.selectedPositivePoints) { old, new in
                        if old != new {
                            Task {
                                await self.viewModel.selectPositivePoint(new)
                            }
                        }
                    }
                    .onChange(of: self.isNegativePointsSelected) { old, new in
                        if old != new { self.updateCompleteButtonEnabled() }
                    }
                    .onChange(of: self.selectedNegativePoints) { old, new in
                        if old != new {
                            Task {
                                await self.viewModel.selectNegativePoint(new)
                            }
                        }
                    }
                    
                    
                    // MARK: Review Content
                    
                    Spacer().frame(height: 32)
                    
                    ReviewContentView(reviewContent: $reviewContent)
                    
                    Spacer().frame(height: 32)
                    
                    AttendeesCheckView(
                        members: self.viewModel.nicknames,
                        isAttendeesSelected: $isAttendeesSelected,
                        selectedAttendees: $selectedAttendees,
                        isNoShowMembersSelected: $isNoShowMembersSelected,
                        selectedNoShowMembers: $selectedNoShowMembers
                    )
                    .onChange(of: self.isAttendeesSelected) { old, new in
                        if old != new { self.updateCompleteButtonEnabled() }
                    }
                    .onChange(of: self.selectedAttendees) { old, new in
                        guard let selectedAttendee = new.last else { return }
                        
                        if old.last != selectedAttendee {
                            Task {
                                await self.viewModel.selectAttendee(selectedAttendee)
                            }
                        }
                    }
                    .onChange(of: self.isNoShowMembersSelected) { old, new in
                        if old != new { self.updateCompleteButtonEnabled() }
                    }
                    .onChange(of: self.selectedNoShowMembers) { old, new in
                        if old != new {
                            Task {
                                await self.viewModel.selectNoShowMembers(new)
                            }
                        }
                    }
                }
            }
            
            Spacer()
            
            BottomButton(
                isClickable: $isCompleteButtonEnabled,
                title: Constants.Text.completeButtonTitle,
                buttonTapAction: {
                    Task {
                        await self.viewModel.submit()
                    }
                }
            )
        }
        .navigationBarBackButtonHidden()
        .onChange(of: self.viewModel.currentState.isSuccess) { _, new in
            if new { self.appPathManager.pop() }
        }
    }
}

extension MeetingReviewView {
    
    private func updateCompleteButtonEnabled() {
        
        // 참석하지 않은 멤버가 있을 때, 참석하지 않은 멤버를 선택해야 완료 버튼 활성화
        let hasNoShowMembers = self.selectedAttendees.last == .hasNoAttendees
        if hasNoShowMembers {
            
            self.isCompleteButtonEnabled = self.isReviewSelected &&
                self.isPositivePointsSelected &&
                self.isNegativePointsSelected &&
                self.isAttendeesSelected &&
                self.isNoShowMembersSelected
        } else {
            
            self.isCompleteButtonEnabled = self.isReviewSelected &&
                self.isPositivePointsSelected &&
                self.isNegativePointsSelected &&
                self.isAttendeesSelected
        }
    }
}

#Preview {
    MeetingReviewView(
        appPathManager: .constant(OTAppPathManager()),
        viewModel: .constant(MeetingReviewViewModel(nicknames: [], id: "123", type: .random))
    )
}
