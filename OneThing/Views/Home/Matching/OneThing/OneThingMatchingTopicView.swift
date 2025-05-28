//
//  OneThingMatchingTopicView.swift
//  OneThing
//
//  Created by 오현식 on 5/27/25.
//

import SwiftUI

struct OneThingMatchingTopicView: View {
    
    enum Constants {
        enum Text {
            static let naviTitle = "원띵 모임 신청"
            
            static let title = "모임에서 이야기하고 싶은\n주제를 알려주세요"
            static let subTitle = "ex. 유럽 여행기 대화 나눠요"
            
            static let placeholderText = "최소 8자, 최대 50자까지 입력할 수 있어요"
            
            static let nextButtonTitle = "다음"
        }
        
        static let progress = 2.0 / 6.0
        static let maxCharacters = 50
    }
    
    @Binding var appPathManager: OTAppPathManager
    @Binding var viewModel: OneThingMatchingViewModel
    
    @State private var isNextButtonEnabled: Bool = false
    
    var body: some View {
        
        VStack {
            
            NavigationBar()
                .title(Constants.Text.naviTitle)
                .hidesBottomSeparator(true)
                .onBackButtonTap {
                    self.viewModel.initializeState(.topic)
                    self.appPathManager.pop()
                }
            
            LinerProgressView(value: Constants.progress, shape: Rectangle())
                .tint(.purple400)
            
            Spacer().frame(height: 32)
            
            GuideMessageView(
                isChangeSubTitleColor: .constant(false),
                title: Constants.Text.title
            )
            
            Spacer().frame(height: 24)
            
            EnterContentView(
                content: $viewModel.currentState.topicContent,
                buttonEnable: $isNextButtonEnabled,
                title: Constants.Text.subTitle,
                placeholder: Constants.Text.placeholderText,
                maxCharacters: Constants.maxCharacters
            )
            
            Spacer()
            
            BottomButton(
                isClickable: $isNextButtonEnabled,
                title: Constants.Text.nextButtonTitle,
                buttonTapAction: { self.appPathManager.push(path: .oneThing(.location)) }
            )
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    OneThingMatchingTopicView(
        appPathManager: .constant(OTAppPathManager()),
        viewModel: .constant(OneThingMatchingViewModel())
    )
}
