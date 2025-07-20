//
//  RandomMatchingTMIView.swift
//  OneThing
//
//  Created by 오현식 on 5/15/25.
//

import SwiftUI

struct RandomMatchingTMIView: View {
    
    enum Constants {
        enum Text {
            static let naviTitle = "랜덤 모임 신청"
            
            static let title = "마지막으로 모임에서 나눌\nTMI를 입력해주세요"
            static let subTitle = "ex. 저는 시드니에 사는 것이 꿈이에요"
            
            static let placeholderText = "최소 8자, 최대 50자까지 입력할 수 있어요"
            
            static let completeButtonTitle = "완료"
        }
        
        static let progress = 1.0
        static let maxCharacters = 50
    }
    
    @Binding var appPathManager: OTAppPathManager
    @Binding var viewModel: RandomMatchingViewModel
    
    @State private var isCompleteButtonEnabled: Bool = false
    
    var body: some View {
        
        VStack {
            
            NavigationBar()
                .title(Constants.Text.naviTitle)
                .hidesBottomSeparator(true)
                .onBackButtonTap { self.appPathManager.pop() }
            
            LinerProgressView(value: Constants.progress, shape: Rectangle())
                .tint(.purple400)
            
            Spacer().frame(height: 32)
            
            GuideMessageView(
                isChangeSubTitleColor: .constant(false),
                title: Constants.Text.title
            )
            
            Spacer().frame(height: 24)
            
            EnterContentView(
                content: $viewModel.currentState.tmiContent,
                buttonEnable: $isCompleteButtonEnabled,
                title: Constants.Text.subTitle,
                placeholder: Constants.Text.placeholderText,
                maxCharacters: Constants.maxCharacters
            )
            
            Spacer()
            
            BottomButton(
                isClickable: $isCompleteButtonEnabled,
                title: Constants.Text.completeButtonTitle,
                buttonTapAction: {
                    self.appPathManager.push(path: .random(.payment))
                }
            )
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    RandomMatchingTMIView(
        appPathManager: .constant(OTAppPathManager()),
        viewModel: .constant(RandomMatchingViewModel())
    )
}
