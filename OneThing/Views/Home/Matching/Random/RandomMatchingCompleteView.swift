//
//  RandomMatchingCompleteView.swift
//  OneThing
//
//  Created by 오현식 on 5/15/25.
//

import SwiftUI

struct RandomMatchingCompleteView: View {
    
    enum Constants {
        enum Text {
            static let naviTitle = "랜덤 모임 신청"
            
            static let title = "모임 신청이 완료되었어요"
            static let subTitle = "신청한 모임은 ‘내 모임-모임 내역’에서 확인할 수 있어요"
            
            static let placeholderText = "그래픽 추가 예정"
            
            static let goMeetingDetailsButtonTitle = "모임 내역 보기"
            static let goHomeButtonTitle = "홈으로 돌아가기"
        }
        
        static let progress = 2.0 / 3.0
        static let maxCharacters = 50
    }
    
    @Binding var appPathManager: OTAppPathManager
    @Binding var viewModel: RandomMatchingViewModel
    
    var body: some View {
        
        VStack {
            NavigationBar()
                .title(Constants.Text.naviTitle)
                .hidesBackButton(true)
                .hidesBottomSeparator(false)
                .rightButtons([
                    Button {
                        self.appPathManager.popToRoot()
                    } label: {
                        Image(.closeOutlined)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.gray500)
                    }
                ])
            
            Spacer().frame(height: 32)
            
            Text(Constants.Text.title)
                .otFont(.heading2)
                .multilineTextAlignment(.leading)
                .foregroundStyle(.gray800)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer().frame(height: 4)
            
            Text(Constants.Text.subTitle)
                .otFont(.subtitle2)
                .multilineTextAlignment(.leading)
                .foregroundStyle(.gray600)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            Text(Constants.Text.placeholderText)
                .otFont(.subtitle2)
                .foregroundStyle(.gray400)
            Spacer()
            
            Rectangle()
                .frame(width: nil, height: 1)
                .foregroundStyle(.gray200)
            
            Spacer().frame(height: 8)
            
            HStack(spacing: 10) {
                Button {
                    // TODO: 모임 내역 화면으로 이동
                } label: {
                    Text(Constants.Text.goMeetingDetailsButtonTitle)
                        .otFont(.title1)
                        .foregroundStyle(.purple400)
                        
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(.white100)
                .clipShape(.rect(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.purple400, lineWidth: 1)
                )
                
                OTXXLButton(
                    buttonTitle: Constants.Text.goHomeButtonTitle,
                    action: {
                        self.appPathManager.popToRoot()
                    },
                    isClickable: true
                )
            }
            .padding(.horizontal, 16)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    RandomMatchingCompleteView(
        appPathManager: .constant(OTAppPathManager()),
        viewModel: .constant(RandomMatchingViewModel())
    )
}
