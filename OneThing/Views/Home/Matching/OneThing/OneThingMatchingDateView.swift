//
//  OneThingMatchingDateView.swift
//  OneThing
//
//  Created by 오현식 on 5/27/25.
//

import SwiftUI

struct OneThingMatchingDateView: View {
    
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
    
    @Binding var appPathManager: OTAppPathManager
    @Binding var viewModel: OneThingMatchingViewModel
    
    @State private var isReachedLimit: Bool = false
    @State private var isNextButtonEnabled: Bool = false
    
    var body: some View {
        
        VStack {
            
            NavigationBar()
                .title(Constants.Text.naviTitle)
                .hidesBottomSeparator(true)
                .onBackButtonTap {
                    self.viewModel.initializeState(.date)
                    self.appPathManager.pop()
                }
            
            LinerProgressView(value: Constants.progress, shape: Rectangle())
                .tint(.purple400)
            
            Spacer().frame(height: 32)
            
            GuideMessageView(
                isChangeSubTitleColor: $isReachedLimit,
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
                        selectLimit: 3
                    ),
                    isReachedLimit: $isReachedLimit,
                    isSelected: $isNextButtonEnabled,
                    selectedDates: $viewModel.currentState.selectedDates
                )
                /// view height + 상단 마진(10)
                .frame(height: 118)
                
                Spacer().frame(height: 32)
                
                Text(Constants.Text.selectDateTitle)
                    .otFont(.body1)
                    .foregroundStyle(.gray800)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer().frame(height: 4)
                    
                if self.viewModel.currentState.selectedDates.isEmpty == false {
                    VStack {
                        ForEach(
                            self.viewModel.currentState.selectedDates,
                            id: \.self
                        ) { date in
                            SelectDateView(
                                matchingDate: date,
                                matchingTime: Constants.Text.meetingTime,
                                onCloseButtonTapped: {
                                    self.viewModel.removeSelectedDate(date)
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
                buttonTapAction: { self.appPathManager.push(path: .oneThing(.payment)) }
            )
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    OneThingMatchingDateView(
        appPathManager: .constant(OTAppPathManager()),
        viewModel: .constant(OneThingMatchingViewModel())
    )
}
