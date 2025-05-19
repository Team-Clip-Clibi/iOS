//
//  MyPageReportMatchingView.swift
//  OneThing
//
//  Created by 윤동주 on 5/11/25.
//

import SwiftUI

struct MyPageReportMatchingView: View {
    
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
            
            VStack(spacing: 0) {
                InfoRow(
                    title: "폭언, 비속어, 혐오 발언",
                    value: "",
                    isClickable: true,
                    action: {
                        selectReportCategory(.slang)
                    })
                
                InfoRow(
                    title: "불법 행위 및 범죄 관련",
                    value: "",
                    isClickable: true,
                    action: {
                        selectReportCategory(.crime)
                    })
                
                InfoRow(
                    title: "성적 수치심 유발",
                    value: "",
                    isClickable: true,
                    action: {
                        selectReportCategory(.sex)
                    })
                
                InfoRow(
                    title: "사기 및 허위 정보",
                    value: "",
                    isClickable: true,
                    action: {
                        selectReportCategory(.false)
                    })
                
                InfoRow(
                    title: "서비스 악용 및 부정행위",
                    value: "",
                    isClickable: true,
                    action: {
                        selectReportCategory(.abusing)
                    })
                
                InfoRow(
                    title: "기타",
                    value: "",
                    isClickable: true,
                    action: {
                        selectReportCategory(.etc)
                    })
            }
            .padding(.top, 20)
            .padding(.horizontal, 17)
            
            Spacer()
        }
        .onAppear {
            pathManager.isTabBarHidden = true
        }
        .navigationBarBackButtonHidden()
    }
    
    private func selectReportCategory(_ category: ReportCategory) {
        viewModel.reportCategory = category
        Task {
            withAnimation(.easeInOut(duration: 0.3)) {
                pathManager.isTabBarHidden = true
            }
            
            try await Task.sleep(nanoseconds: 300_000_000)
            
            pathManager.push(path: .reportReason)
        }
    }
}

#Preview {
    MyPageReportMatchingView(
        pathManager: .constant(OTAppPathManager()),
        viewModel: .constant(MyPageReportViewModel())
    )
}
