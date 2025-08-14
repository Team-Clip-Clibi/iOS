//
//  MyPageReportMatchingView.swift
//  OneThing
//
//  Created by 윤동주 on 5/11/25.
//

import SwiftUI

struct MyPageReportMatchingView: View {
    
    @Environment(\.myPageCoordinator) var myPageCoordinator
    
    @Binding var store: MyPageReportStore
    
    var body: some View {
        
        OTBaseView(String(describing: Self.self)) {
            
            VStack(spacing: 0) {
                
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
                .onChange(of: self.store.state.reportCategory) { _, newValue in
                    if newValue == .etc { self.myPageCoordinator.push(to: .myPage(.reportReason)) }
                }
                
                Spacer()
            }
        }
        .navigationBar(
            title: "매칭 관련 신고하기",
            onBackButtonTap: {
                self.myPageCoordinator.pop()
            }
        )
    }
    
    private func selectReportCategory(_ category: ReportCategory) {
        Task {
            await self.store.send(.updateCategory(category))
        }
    }
}

#Preview {
    let myPageReportStoreForPreview = MyPageReportStore(submitReportUseCase: SubmitReportUseCase())
    MyPageReportMatchingView(store: .constant(myPageReportStoreForPreview))
}
