//
//  InMeetingCompleteView.swift
//  OneThing
//
//  Created by 오현식 on 6/5/25.
//

import SwiftUI

struct InMeetingCompleteView: View {
    
    enum Constants {
        enum Text {
            static let title = "마무리"
            static let subTitle = "즐거운 시간 보내셨나요?"
            static let message = "짧은 시간이지만, 깊이 있는 대화를 나누셨길 바라요\n이야기를 더 나누고 싶다면 2차를 가는 것도 추천해요"
            
            static let content = "오늘의 원띵으로\n좋은 인사이트를 얻으셨길 바라요"
            
            static let endMeetingButtonTitle = "종료"
        }
    }
    
    @Binding var inMeetingPathManager: OTInMeetingPathManager
    @Binding var viewModel: InMeetingViewModel
    
    var body: some View {
        
        VStack {
            InMeetingGuideMessageView(
                title: Constants.Text.title,
                subTitle: Constants.Text.subTitle,
                message: Constants.Text.message
            )
            
            Spacer().frame(height: 32)
            
            ScrollView(.vertical, showsIndicators: false) {
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.purple100)
                    
                    VStack(spacing: 32) {
                        Image(.quit)
                            .resizable()
                            .frame(width: 267, height: 223)
                        
                        Text(Constants.Text.content)
                            .otFont(.title1)
                            .foregroundStyle(.gray800)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity)
                .frame(height: 460)
            }
            
            Spacer()
            
            OTXXLButton(
                buttonTitle: Constants.Text.endMeetingButtonTitle,
                action: {
                    Task { await self.viewModel.meetingEnded() }
                },
                isClickable: true
            )
            .padding(.bottom, 12)
            .padding(.horizontal, 24)
        }
        .navigationBarBackButtonHidden()
        .onChange(of: self.viewModel.currentState.isMeetingEnded) { _, new in
            if new {
                NotificationCenter.default.post(
                    name: .showMeetingReviewAlert,
                    object: [
                        "nicknames": self.viewModel.initalState.nicknames,
                        "matchingId": self.viewModel.initalState.matchingId,
                        "matchingType": self.viewModel.initalState.matchingType
                    ]
                )
                self.inMeetingPathManager.popToRoot()
            }
        }
    }
}

#Preview {
    InMeetingCompleteView(
        inMeetingPathManager: .constant(OTInMeetingPathManager()),
        viewModel: .constant(
            InMeetingViewModel(
                inMeetingInfo: InMeetingInfo(
                    matchingId: "",
                    matchingType: .onething,
                    nicknameList: [],
                    quizList: [],
                    oneThingMap: [:]
                )
            )
        )
    )
}
