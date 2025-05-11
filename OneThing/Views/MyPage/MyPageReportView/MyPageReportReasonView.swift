//
//  MyPageReportReasonView.swift
//  OneThing
//
//  Created by 윤동주 on 5/11/25.
//

import SwiftUI

struct MyPageReportReasonView: View {
    
    @Binding var pathManager: OTAppPathManager
    @Binding var viewModel: MyPageReportViewModel
    
    var body: some View {
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
                    Task {
                        let result = try await viewModel.submitReport()
                        if result {
                            pathManager.pop()
                        }
                    }
                },
                isClickable: !viewModel.content.isEmpty)
            .padding(.horizontal, 17)
            .padding(.top, 10)
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
