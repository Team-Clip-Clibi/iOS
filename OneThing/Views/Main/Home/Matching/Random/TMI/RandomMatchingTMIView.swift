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
            static let subTitleFirst = "ex. 저는 시드니에 사는 것이 꿈이에요"
            static let subTitleSecond = "ex. 저는 매년 생일마다 증명사진을 찍어서 모아요"
            
            static let placeholderText = "최소 8자, 최대 50자까지 입력할 수 있어요"
            
            static let completeButtonTitle = "완료"
        }
        
        static let progress = 1.0
        static let maxCharacters = 50
    }
    
    @Environment(\.homeCoordinator) var homeCoordinator
    
    @Binding var store: RandomMatchingStore
    
    @State private var isCompleteButtonEnabled: Bool = false
    @State private var tmiContents: String = ""
    
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
                    content: $tmiContents,
                    buttonEnable: $isCompleteButtonEnabled,
                    titles: [Constants.Text.subTitleFirst, Constants.Text.subTitleSecond],
                    placeholder: Constants.Text.placeholderText,
                    maxCharacters: Constants.maxCharacters
                )
                .onChange(of: self.tmiContents) { _, new in
                    Task { await self.store.send(.updateTmiContents(new)) }
                }
                
                Spacer()
                
                BottomButton(
                    isClickable: $isCompleteButtonEnabled,
                    title: Constants.Text.completeButtonTitle,
                    buttonTapAction: { self.homeCoordinator.push(to: .home(.random(.payment))) }
                )
            }
        }
        .navigationBar(
            title: Constants.Text.naviTitle,
            hidesBottomSeparator: true,
            onBackButtonTap: {
                Task { await self.store.send(.updateTmiContents(""))}
                self.homeCoordinator.pop()
            }
        )
    }
}

#Preview {
    RandomMatchingTMIView(store: .constant(RandomMatchingStore(with: "현식")))
}
