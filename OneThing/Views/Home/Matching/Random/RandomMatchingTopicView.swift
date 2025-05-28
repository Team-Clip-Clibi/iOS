//
//  RandomMatchingTopicView.swift
//  OneThing
//
//  Created by 오현식 on 5/15/25.
//

import SwiftUI

struct RandomMatchingTopicView: View {
    
    enum Constants {
        enum Text {
            static let naviTitle = "랜덤 모임 신청"
            
            static let title = "모임에서 나누고 싶은\n대화 주제를 입력해주세요"
            static let subTitle = "ex. 유럽 여행기 대화 나눠요"
            
            static let placeholderText = "최소 8자, 최대 50자까지 입력할 수 있어요"
            
            static let nextButtonTitle = "다음"
        }
        
        static let progress = 2.0 / 3.0
        static let maxCharacters = 50
    }
    
    @Binding var appPathManager: OTAppPathManager
    @Binding var viewModel: RandomMatchingViewModel
    
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
                buttonTapAction: {
                    self.appPathManager.push(path: .random(.tmi))
                }
            )
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    RandomMatchingTopicView(
        appPathManager: .constant(OTAppPathManager()),
        viewModel: .constant(RandomMatchingViewModel())
    )
}
