//
//  MyPageReportMainView.swift
//  OneThing
//
//  Created by 윤동주 on 5/6/25.
//

import SwiftUI

struct MyPageReportMainView: View {
    
    @Environment(\.myPageCoordinator) var myPageCoordinator
    
    @Binding var store: MyPageReportStore
    
    var body: some View {
        
        OTBaseView(String(describing: Self.self)) {
            
            VStack {
                
                VStack {
                    HStack {
                        Text("서비스 이용 중 불편한 점이 있으셨나요?")
                            .otFont(.title1)
                            .fontWeight(.semibold)
                            .foregroundStyle(.gray800)
                        Spacer()
                    }
                    Spacer()
                        .frame(height: 24)
                    InfoRow(
                        title: "매칭 관련 신고하기",
                        value: "",
                        isClickable: true,
                        action: {
                            self.myPageCoordinator.push(to: .myPage(.reportMatching))
                        })
                    
                    InfoRow(
                        title: "서비스 관련 신고하기",
                        value: "",
                        isClickable: true,
                        action: {
                            
                        })
                }
                .padding(.horizontal, 17)
                .padding(.top, 32)
                
                Spacer()
                
                VStack(spacing: 20) {
                    HStack {
                        Text("신고 전, 이용 수칙을 확인해 보세요")
                            .otFont(.title1)
                            .fontWeight(.semibold)
                            .foregroundStyle(.gray800)
                        Spacer()
                    }
                    
                    HStack(spacing: 12) {
                        OTSelectionButton(
                            buttonTitle: "커뮤니티 이용 수칙",
                            action:{
                                
                            },
                            isClicked: false)
                        
                        OTSelectionButton(
                            buttonTitle: "1:1 문의하기",
                            action:{
                                
                            },
                            isClicked: false)
                    }
                }
                .padding(.horizontal, 17)
            }
        }
        .navigationBar(
            title: "신고하기",
            onBackButtonTap: {
                self.myPageCoordinator.pop()
            }
        )
    }
}

extension MyPageReportMainView {
    struct InfoRow: View {
        let title: String
        var value: String
        var isClickable: Bool = false
        var action: (() -> Void)?
        
        var body: some View {
            Button{
                action?()
            } label: {
                HStack {
                    Text(title)
                        .otFont(.body1)
                        .fontWeight(.medium)
                        .foregroundStyle(.gray800)
                    Spacer()
                    HStack {
                        Text(value)
                            .otFont(.body1)
                            .fontWeight(.medium)
                            .foregroundStyle(.gray800)
                        if isClickable {
                            Image(.rightArrowOutlined)
                                .foregroundStyle(.gray400)
                        }
                    }
                }
                .padding(.vertical, 14)
            }
            .disabled(!isClickable)
        }
    }
}

#Preview {
    let myPageReportStoreForPreview = MyPageReportStore(submitReportUseCase: SubmitReportUseCase())
    MyPageReportMainView(store: .constant(myPageReportStoreForPreview))
}
