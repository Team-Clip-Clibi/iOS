//
//  InitialMatchingSelectJobView.swift
//  OneThing
//
//  Created by 오현식 on 5/21/25.
//

import SwiftUI

struct InitialMatchingSelectJobView: View {
    
    enum Constants {
        enum Text {
            static let naviTitle = "모임 신청"
            
            static let title = "현재 하고 계신 일을\n선택해주세요"
            static let subTitle = "최대 1개까지 선택할 수 있어요."
            
            static let nextButtonTitle = "다음"
        }
        
        static let progress = 1.0 / 3.0
    }
    
    @Binding var appPathManager: OTAppPathManager
    @Binding var viewModel: InitialMatchingViewModel
    
    @State private var isReachedLimit: Bool = false
    @State private var isNextButtonEnabled: Bool = false
    
    var body: some View {
        
        VStack {
            
            NavigationBar()
                .title(Constants.Text.naviTitle)
                .hidesBottomSeparator(true)
                .onBackButtonTap {
                    self.viewModel.initializeState(.job)
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
            
            Spacer().frame(height: 24)
            
            MultipleOnlyTextBoxView<JobType>(
                state: .init(
                    items: JobType.allCases.map { .init(item: $0) },
                    selectLimit: 1
                ),
                isReachedLimit: $isReachedLimit,
                isSelected: $isNextButtonEnabled,
                selectedItems: $viewModel.currentState.selectedJobs,
                cols: [GridItem(), GridItem()],
                alignment: .center
            )
            
            Spacer()
            
            BottomButton(
                isClickable: $isNextButtonEnabled,
                title: Constants.Text.nextButtonTitle,
                buttonTapAction: { self.appPathManager.push(path: .initial(.dietary)) }
            )
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    InitialMatchingSelectJobView(
        appPathManager: .constant(OTAppPathManager()),
        viewModel: .constant(InitialMatchingViewModel())
    )
}
