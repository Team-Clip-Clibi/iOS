//
//  MyPageTermView.swift
//  OneThing
//
//  Created by 윤동주 on 5/11/25.
//

import SwiftUI

struct MyPageTermView: View {
    
    @Environment(\.openURL) private var openURL
    
    @Binding var pathManager: OTAppPathManager
    
    var body: some View {
        VStack(spacing: 0) {
            OTNavigationBar(
                leftButtonType: .back,
                title: "약관 및 정책",
                phase: 0,
                leftAction: {
                    _ = self.pathManager.myPagePaths.popLast()
                }
            )
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
        .onAppear {
            pathManager.isTabBarHidden = true
        }
        .onDisappear {
            pathManager.isTabBarHidden = false
        }
        .navigationBarBackButtonHidden()
    }

}

#Preview {
    MyPageTermView(pathManager: .constant(OTAppPathManager()))
}
