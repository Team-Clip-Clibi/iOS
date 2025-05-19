//
//  MyPageReportReasonView.swift
//  OneThing
//
//  Created by 윤동주 on 5/11/25.
//

import SwiftUI

struct MyPageReportReasonView: View {
    
    @State private var isPopUpVisible: Bool = false
    @FocusState private var isTextEditorFocused: Bool
    
    @Binding var pathManager: OTAppPathManager
    @Binding var viewModel: MyPageReportViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                OTNavigationBar(
                    leftButtonType: .back,
                    title: "매칭 관련 신고하기",
                    phase: 0,
                    leftAction: {
                        _ = self.pathManager.myPagePaths.popLast()
                    }
                )
                
                VStack(spacing: 24) {
                    HStack {
                        Text("신고 사유를 작성해주세요.")
                            .otFont(.title1)
                            .fontWeight(.semibold)
                            .foregroundStyle(.gray800)
                        Spacer()
                    }
                    
                    TextEditor(text: $viewModel.content)
                        .customStyleEditor(placeholder: "모임 및 멤버의 닉네임 등 구체적인 정보와 함께 신고 사유를 입력해 주세요.", userInput: $viewModel.content)
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
                    isClickable: !viewModel.content.isEmpty)
                .padding(.horizontal, 17)
                .padding(.top, 10)
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
                                let result = try await viewModel.submitReport()
                                if result {
                                    viewModel.initReport()
                                    pathManager.pop()
                                }
                            }
                        }
                    )
                    
                }
                .ignoresSafeArea()
            }
        }
        .task {
            Task {
                pathManager.isTabBarHidden = true
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    MyPageReportReasonView(
        pathManager: .constant(OTAppPathManager()),
        viewModel: .constant(MyPageReportViewModel())
    )
}
