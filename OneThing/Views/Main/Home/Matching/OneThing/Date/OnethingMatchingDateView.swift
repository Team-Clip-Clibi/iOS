//
//  OnethingMatchingDateView.swift
//  OneThing
//
//  Created by 오현식 on 5/27/25.
//

import SwiftUI

struct OnethingMatchingDateView: View {
    
    enum Constants {
        enum Text {
            static let naviTitle = "원띵 모임 신청"
            
            static let title = "참여 가능한 모임 날짜를\n선택해주세요"
            static let subTitle = "최대 3개까지 선택할 수 있어요"
            
            static let meetingTime = "오후 7시"
            static let selectDateTitle = "선택한 날짜"
            
            static let nextButtonTitle = "다음"
        }
        
        static let progress = 1.0
    }
    
    @Environment(\.homeCoordinator) var homeCoordinator
    
    @Binding var store: OnethingMatchingStore
    
    @State private var isNextButtonEnabled: Bool = false
    @State private var selectedDates: [String] = []
    
    var body: some View {
        
        OTBaseView(String(describing: Self.self)) {
            
            VStack {
                
                LinerProgressView(value: Constants.progress, shape: Rectangle())
                    .tint(.purple400)
                
                Spacer().frame(height: 32)
                
                GuideMessageView(
                    isChangeSubTitleColor: .constant(false),
                    title: Constants.Text.title,
                    subTitle: Constants.Text.subTitle
                )
                
                Spacer().frame(height: 14)
                
                VStack {
                    
                    MultipleDateTextBoxView(
                        state: .init(
                            items: Date().findWeekendDates().map {
                                .init(
                                    matchingDate: $0,
                                    matchingTime: Constants.Text.meetingTime
                                )
                            },
                            selectLimit: 3,
                            changeWhenIsReachedLimit: true
                        ),
                        isReachedLimit: .constant(false),
                        isSelected: $isNextButtonEnabled,
                        selectedDates: $selectedDates
                    )
                    /// view height + 상단 마진(10)
                    .frame(height: 118)
                    .onChange(of: self.selectedDates) { _, new in
                        Task { await self.store.send(.updateDates(new)) }
                    }
                    
                    Spacer().frame(height: 32)
                    
                    Text(Constants.Text.selectDateTitle)
                        .otFont(.body1)
                        .foregroundStyle(.gray800)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer().frame(height: 4)
                        
                    if self.store.state.selectedDates.isEmpty == false {
                        VStack {
                            ForEach(
                                self.store.state.selectedDates,
                                id: \.self
                            ) { date in
                                SelectDateView(
                                    matchingDate: date,
                                    matchingTime: Constants.Text.meetingTime,
                                    onCloseButtonTapped: {
                                        let updatedDates = self.store.state.selectedDates.filter { $0 != date }
                                        // SelectionBox 동기화
                                        self.selectedDates = updatedDates
                                        Task { await self.store.send(.updateDates(updatedDates)) }
                                    }
                                )
                            }
                        }
                    }
                }
                .padding(.leading, 16)
                
                Spacer()
                
                BottomButton(
                    isClickable: $isNextButtonEnabled,
                    title: Constants.Text.nextButtonTitle,
                    buttonTapAction: { self.homeCoordinator.push(to: .home(.onething(.payment))) }
                )
            }
        }
        .navigationBar(
            title: Constants.Text.naviTitle,
            hidesBottomSeparator: true,
            onBackButtonTap: {
                Task { await self.store.send(.updateDates([])) }
                self.homeCoordinator.pop()
            }
        )
    }
}

#Preview {
    let onethingMatchingStoreForPreview = OnethingMatchingStore(
        submitOnethingsOrderUseCase: SubmitOnethingsOrderUseCase(),
        submitPaymentsConfirmUseCase: SubmitPaymentsConfirmUseCase()
    )
    OnethingMatchingDateView(store: .constant(onethingMatchingStoreForPreview))
}
