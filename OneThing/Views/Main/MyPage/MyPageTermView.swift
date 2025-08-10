//
//  MyPageTermView.swift
//  OneThing
//
//  Created by 윤동주 on 5/11/25.
//

import SwiftUI

struct MyPageTermView: View {
    
    @Environment(\.openURL) private var openURL
    @Environment(\.myPageCoordinator) var myPageCoordinator
    
    var body: some View {
        
        OTBaseView(String(describing: Self.self)) {
            
            VStack(spacing: 0) {
                
                VStack(spacing: 0) {
                    InfoRow(title: "개인정보 처리방침", value: "", isClickable: true, action: {
                        openURL(URL(string: "Constant.URL.privacyPolicyUrl")!)
                    })
                    
                    InfoRow(title: "이용약관", value: "", isClickable: true, action: {
                        openURL(URL(string: "Constant.URL.privacyPolicyUrl")!)
                    })
                    
                    InfoRow(title: "커뮤니티 가이드라인", value: "", isClickable: true, action: {
                        openURL(URL(string: "Constant.URL.privacyPolicyUrl")!)
                    })
                }
                .padding(.horizontal, 17)
                .padding(.top, 20)
                
                Spacer()
            }
        }
        .navigationBar(
            title: "약관 및 정책",
            onBackButtonTap: {
                self.myPageCoordinator.pop()
            }
        )
    }

}

#Preview {
    MyPageTermView()
}
