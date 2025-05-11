//
//  OTConfirmAlertView.swift
//  OneThing
//
//  Created by 윤동주 on 5/11/25.
//


import SwiftUI

struct OTConfirmAlertView: View {
    
    var title: String = ""
    var subTitle: String = ""
    var buttonTitle: String = ""
    
    var action: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .otFont(.title1)
                .fontWeight(.semibold)
                .foregroundStyle(.gray800)
            
            Text(subTitle)
                .otFont(.body1)
                .fontWeight(.medium)
                .foregroundStyle(.gray600)
                .padding(.top, 6)
            
            VStack(spacing: 10) {
                OTMButton(buttonTitle: buttonTitle, action: {
                    action?()
                }, isClickable: true)
            }
            .padding(.top, 24)
        }
        .padding(.all, 24)
        .background(.gray100)
        .cornerRadius(24)
        .frame(maxWidth: 324, minHeight: 194)
    }
}

#Preview {
    OTAlertView(
        title: "정말 원띵을 떠나실건가요?",
        subTitle: "계정이 삭제되면 모든 데이터가 영구 삭제됩니다.",
        firstButton: "탈퇴하기"
    )
}
