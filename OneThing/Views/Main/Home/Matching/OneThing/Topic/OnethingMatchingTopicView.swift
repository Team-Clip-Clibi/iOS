//
//  OnethingMatchingTopicView.swift
//  OneThing
//
//  Created by 오현식 on 5/27/25.
//

import SwiftUI

struct OnethingMatchingTopicView: View {
    
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
    
    @Environment(\.homeCoordinator) var homeCoordinator
    
    @Binding var store: OnethingMatchingStore
    
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
                    title: Constants.Text.subTitle,
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
                    buttonTapAction: { self.homeCoordinator.push(to: .home(.onething(.location))) }
                )
            }
        }
        .navigationBar(
            title: Constants.Text.naviTitle,
            hidesBottomSeparator: true,
            onBackButtonTap: {
                Task { await self.store.send(.updateTopicContents("")) }
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
    OnethingMatchingTopicView(store: .constant(onethingMatchingStoreForPreview))
}
