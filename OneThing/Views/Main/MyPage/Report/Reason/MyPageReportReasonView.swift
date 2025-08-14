//
//  MyPageReportReasonView.swift
//  OneThing
//
//  Created by 윤동주 on 5/11/25.
//

import SwiftUI

struct MyPageReportReasonView: View {
    
    @Environment(\.myPageCoordinator) var myPageCoordinator
    
    @Binding var store: MyPageReportStore
    
    @State private var content: String = ""
    @State private var isPopUpVisible: Bool = false
    @FocusState private var isTextEditorFocused: Bool
    
    var body: some View {
        
        ZStack {
            
            OTBaseView(String(describing: Self.self)) {
                
                VStack(spacing: 0) {
                    
                    VStack(spacing: 24) {
                        HStack {
                            Text("신고 사유를 작성해주세요.")
                                .otFont(.title1)
                                .fontWeight(.semibold)
                                .foregroundStyle(.gray800)
                            Spacer()
                        }
                        
                        TextEditor(text: $content)
                            .customStyleEditor(
                                placeholder: "모임 및 멤버의 닉네임 등 구체적인 정보와 함께 신고 사유를 입력해 주세요.",
                                userInput: $content
                            )
                            .frame(height: 200)
                            .focused($isTextEditorFocused)
                    }
                    .padding(.top, 32)
                    .padding(.horizontal, 17)
                    
                    Spacer()
                    
                    Rectangle()
                        .fill(.gray200)
                        .frame(height: 1)
                    
                    OTXXLButton(
                        buttonTitle: "완료",
                        action: {
                            self.isPopUpVisible = true
                            isTextEditorFocused = false
                        },
                        isClickable: self.content.isEmpty == false
                    )
                    .padding(.horizontal, 17)
                    .padding(.top, 10)
                }
                .onChange(of: self.store.state.isReported) { _, newValue in
                    if newValue { self.myPageCoordinator.popToRoot() }
                }
                
                if isPopUpVisible {
                    ZStack {
                        Color.black.opacity(0.4)
                            .transition(.opacity)
                        
                        OTConfirmAlertView(
                            title: "신고가 성공적으로 접수되었어요",
                            subTitle: "신고 답변은 7일 이내에 카카오톡으로 보내드리겠습니다. 감사합니다.",
                            buttonTitle: "확인",
                            action: {
                                Task {
                                    self.isPopUpVisible = false
                                    await self.store.send(.submitReport(self.content))
                                }
                            }
                        )
                        
                    }
                    .ignoresSafeArea()
                }
            }
            .navigationBar(
                title: "매칭 관련 신고하기",
                onBackButtonTap: {
                    self.myPageCoordinator.pop()
                }
            )
        }
    }
}

#Preview {
    let myPageReportStoreForPreview = MyPageReportStore(submitReportUseCase: SubmitReportUseCase())
    MyPageReportReasonView(store: .constant(myPageReportStoreForPreview))
}
