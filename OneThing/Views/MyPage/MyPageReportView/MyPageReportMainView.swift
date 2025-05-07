//
//  MyPageReportMainView.swift
//  OneThing
//
//  Created by 윤동주 on 5/6/25.
//

import SwiftUI

struct MyPageReportMainView: View {
    
    @Binding var pathManager: OTAppPathManager
    @Binding var viewModel: MyPageReportViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            OTNavigationBar(
                rightButtonType: .close,
                title: "신고하기",
                phase: 0,
                rightAction: {
                    _ = self.pathManager.myPagePaths.popLast()
                }
            )
            
            HStack {
                Text("서비스 이용 중 불편한 점이 있으셨나요?")
                    .otFont(.title1)
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray800)
                Spacer()
            }
            
            InfoRow(
                title: "매칭 관련 신고하기",
                value: "",
                isClickable: true,
                action: {
                
            })
            
            InfoRow(
                title: "서비스 관련 신고하기",
                value: "",
                isClickable: true,
                action: {
                
            })
            
        }
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
                            Image(.rightArrow)
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
    MyPageReportMainView(
        pathManager: .constant(OTAppPathManager()),
        viewModel: .constant(MyPageReportViewModel())
    )
}
