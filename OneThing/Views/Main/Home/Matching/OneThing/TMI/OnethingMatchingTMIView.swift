//
//  OnethingMatchingTMIView.swift
//  OneThing
//
//  Created by 오현식 on 5/27/25.
//

import SwiftUI

struct OnethingMatchingTMIView: View {
    
    enum Constants {
        enum Text {
            static let naviTitle = "원띵 모임 신청"
            
            static let title = "모임에서 나눌 나의 TMI를\n입력해주세요"
            static let subTitle = "ex. 저는 매년 생일마다 증명사진을 찍어서 모아요"
            
            static let placeholderText = "최소 8자, 최대 50자까지 입력할 수 있어요"
            
            static let nextButtonTitle = "다음"
        }
        
        static let progress = 5.0 / 6.0
        static let maxCharacters = 50
    }
    
    @Environment(\.homeCoordinator) var homeCoordinator
    
    @Binding var store: OnethingMatchingStore
    
    @State private var isNextButtonEnabled: Bool = false
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
                    buttonEnable: $isNextButtonEnabled,
                    title: Constants.Text.subTitle,
                    placeholder: Constants.Text.placeholderText,
                    maxCharacters: Constants.maxCharacters
                )
                .onChange(of: self.tmiContents) { _, new in
                    Task { await self.store.send(.updateTmiContents(new)) }
                }
                
                Spacer()
                
                BottomButton(
                    isClickable: $isNextButtonEnabled,
                    title: Constants.Text.nextButtonTitle,
                    buttonTapAction: { self.homeCoordinator.push(to: .home(.onething(.date))) }
                )
            }
        }
        .navigationBar(
            title: Constants.Text.naviTitle,
            hidesBottomSeparator: true,
            onBackButtonTap: {
                Task { await self.store.send(.updateTmiContents("")) }
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
    OnethingMatchingTMIView(store: .constant(onethingMatchingStoreForPreview))
}
