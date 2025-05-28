//
//  InitialMatchingMainView.swift
//  OneThing
//
//  Created by 오현식 on 5/21/25.
//

import SwiftUI

struct InitialMatchingMainView: View {
    
    enum ConstText {
        
        static let naviTitle = "랜덤 모임 신청"
        
        static let title = "모임 신청을 위해\n몇 가지 정보가 필요해요"
        static let subTitle = "입력한 정보는 이후 자동으로 적용되며, 수정이 가능해요"
        
        static let message = "첫 모임 신청을 환영해요!"
        
        static let nextButtonTitle = "다음"
    }
    
    @Binding var appPathManager: OTAppPathManager
    @Binding var viewModel: InitialMatchingViewModel
    
    var body: some View {
        
        VStack {
            
            NavigationBar()
                .title(ConstText.naviTitle)
                .hidesBottomSeparator(true)
                .onBackButtonTap {
                    self.appPathManager.pop()
                    self.appPathManager.isTabBarHidden = false
                }
            
            Spacer().frame(height: 16)
            
            ScrollView(.vertical, showsIndicators: false) {
                GuideMessageView(
                    isChangeSubTitleColor: .constant(false),
                    title: ConstText.title,
                    subTitle: ConstText.subTitle
                )
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.purple100)
                    
                    VStack(spacing: 32) {
                        Image(.matchingInitial)
                        
                        Text(ConstText.message)
                            .otFont(.title1)
                            .foregroundStyle(.gray800)
                    }
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
                .frame(height: 460)
            }
            
            Spacer()
            
            BottomButton(
                isClickable: .constant(true),
                title: ConstText.nextButtonTitle,
                buttonTapAction: { self.appPathManager.push(path: .initial(.job)) }
            )
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    InitialMatchingMainView(
        appPathManager: .constant(OTAppPathManager()),
        viewModel: .constant(InitialMatchingViewModel())
    )
}
