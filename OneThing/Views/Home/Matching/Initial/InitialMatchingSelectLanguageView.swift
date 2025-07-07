//
//  InitialMatchingSelectLanguageView.swift
//  OneThing
//
//  Created by 오현식 on 5/25/25.
//

import SwiftUI

struct InitialMatchingSelectLanguageView: View {
    
    enum Constants {
        enum Text {
            static let naviTitle = "모임 신청"
            
            static let title = "사용하는 언어를 선택해주세요"
            static let subTitle = "모임 진행을 위해 주로 사용하는 언어를 알려주세요"
            
            static let completeButtonTitle = "완료"
        }
        
        static let progress = 1.0
    }
    
    @Binding var appPathManager: OTAppPathManager
    @Binding var viewModel: InitialMatchingViewModel
    
    @State private var isCompleteButtonEnabled: Bool = false
    
    var body: some View {
        
        VStack {
            
            NavigationBar()
                .title(Constants.Text.naviTitle)
                .hidesBottomSeparator(true)
                .onBackButtonTap {
                    self.viewModel.initializeState(.language)
                    self.appPathManager.pop()
                }
            
            LinerProgressView(value: Constants.progress, shape: Rectangle())
                .tint(.purple400)
            
            Spacer().frame(height: 32)
            
            GuideMessageView(
                isChangeSubTitleColor: .constant(false),
                title: Constants.Text.title,
                subTitle: Constants.Text.subTitle
            )
            
            Spacer().frame(height: 24)
            
            MultipleOnlyTextBoxView<Language>(
                state: .init(
                    items: Language.allCases.map { .init(item: $0) },
                    selectionLimit: 1,
                    changeWhenIsReachedLimit: true
                ),
                isReachedLimit: .constant(false),
                isSelected: $isCompleteButtonEnabled,
                selectedItems: $viewModel.currentState.selectedLanguages,
                cols: [GridItem()],
                alignment: .leading
            )
            
            Spacer()
            
            BottomButton(
                isClickable: $isCompleteButtonEnabled,
                title: Constants.Text.completeButtonTitle,
                buttonTapAction: {
                    Task { await self.viewModel.updateAll() }
                }
            )
        }
        .navigationBarBackButtonHidden()
        .onChange(of: self.viewModel.currentState.isSuccess) { _, new in
            if new { self.appPathManager.pushWhenInitialFinished() }
        }
    }
}

#Preview {
    InitialMatchingSelectLanguageView(
        appPathManager: .constant(OTAppPathManager()),
        viewModel: .constant(InitialMatchingViewModel())
    )
}
