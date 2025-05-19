//
//  RandomMatchingMainView.swift
//  OneThing
//
//  Created by 오현식 on 5/14/25.
//

import SwiftUI

struct RandomMatchingMainView: View {
    
    enum ConstText {
        
        static let naviTitle = "랜덤 모임 신청"
        
        static let title = "매주 월요일 7시,\n랜덤 모임에서 만나요"
        static let subTitle = "새로운 사람과 함께 다양한 이야기를 나눠요"
        
        static let message = "질문이 인연이 되는 월요일 함께할래요?"
        
        static let nextButtonTitle = "다음"
    }
    
    @Binding var appPathManager: OTAppPathManager
    @Binding var viewModel: RandomMatchingViewModel
    
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
                Text(ConstText.title)
                    .otFont(.heading2)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.gray800)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer().frame(height: 2)
                
                Text(ConstText.subTitle)
                    .otFont(.subtitle2)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.gray600)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.gray100)
                    
                    Text(ConstText.message)
                        .otFont(.title1)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.gray600)
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
                .frame(height: 460)
            }
            
            Spacer()
            
            VStack(spacing: 8) {
                Rectangle()
                    .frame(width: nil, height: 1)
                    .foregroundStyle(.gray200)
                
                OTXXLButton(
                    buttonTitle: ConstText.nextButtonTitle,
                    action: {
                        self.appPathManager.push(path: .random(.location))
                    },
                    isClickable: true
                )
                .padding(.horizontal, 16)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    RandomMatchingMainView(
        appPathManager: .constant(OTAppPathManager()),
        viewModel: .constant(RandomMatchingViewModel())
    )
}
