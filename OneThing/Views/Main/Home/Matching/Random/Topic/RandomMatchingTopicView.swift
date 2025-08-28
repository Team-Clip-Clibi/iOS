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
            static let subTitleFirst = "ex. 유럽 여행기 대화 나눠요"
            static let subTitleSecond = "ex. 다들 면접 준비 어떻게 하고 있는지 궁금해요"
            
            static let placeholderText = "최소 8자, 최대 50자까지 입력할 수 있어요"
            
            static let nextButtonTitle = "다음"
        }
        
        static let progress = 2.0 / 3.0
        static let maxCharacters = 50
    }
    
    @Environment(\.homeCoordinator) var homeCoordinator
    
    @Binding var store: RandomMatchingStore
    
    @State private var isNextButtonEnabled: Bool = false
    @State private var topicContents: String = ""
    
    var body: some View {
        
        OTBaseView(String(describing: Self.self)) {
            
            VStack {
                
                LinerProgressView(value: Constants.progress, shape: Rectangle())
                    .tint(.purple400)
                
                Spacer().frame(height: 32)
                
                GuideMessageView(
                    isChangeSubTitleColor: .constant(false),
                    title: Constants.Text.title
                )
                
                Spacer().frame(height: 24)
                
                EnterContentView(
                    content: $topicContents,
                    buttonEnable: $isNextButtonEnabled,
                    titles: [Constants.Text.subTitleFirst, Constants.Text.subTitleSecond],
                    placeholder: Constants.Text.placeholderText,
                    maxCharacters: Constants.maxCharacters
                )
                .onChange(of: self.topicContents) { _, new in
                    Task { await self.store.send(.updateTopicContents(new)) }
                }
                
                Spacer()
                
                BottomButton(
                    isClickable: $isNextButtonEnabled,
                    title: Constants.Text.nextButtonTitle,
                    buttonTapAction: { self.homeCoordinator.push(to: .home(.random(.tmi))) }
                )
            }
        }
        .navigationBar(
            title: Constants.Text.naviTitle,
            hidesBottomSeparator: true,
            onBackButtonTap: {
                Task { await self.store.send(.updateTopicContents(""))}
                self.homeCoordinator.pop()
            }
        )
    }
}

#Preview {
    RandomMatchingTopicView(store: .constant(RandomMatchingStore(with: "현식")))
}
