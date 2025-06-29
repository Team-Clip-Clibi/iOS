//
//  OneThingMatchingFailView.swift
//  OneThing
//
//  Created by 윤동주 on 6/29/25.
//


import SwiftUI

struct OneThingMatchingFailView: View {
    
    enum Constants {
        enum Text {
            static let naviTitle = "원띵 모임 신청"
            
            static let title = "결제에 실패했어요"
            static let subTitle = "일시적인 오류로 결제가 중단되었어요\n잠시 후 다시 시도해 주세요"
            
            static let confirmButtonTitle = "확인"
        }
    }
    
    @Binding var appPathManager: OTAppPathManager
    @Binding var viewModel: OneThingMatchingViewModel
    
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
            
            VStack {
                Image(.fail)
                
                Spacer()
                    .frame(height: 24)
                
                VStack(spacing: 6) {
                    Text(Constants.Text.title)
                        .otFont(.heading2)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.gray800)
                    
                    Text(Constants.Text.subTitle)
                        .otFont(.subtitle2)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.gray600)
                }
            }
            .padding(.top, 180)

            Spacer()
            
            Rectangle()
                .frame(width: nil, height: 1)
                .foregroundStyle(.gray200)
            
            Spacer().frame(height: 8)
            
            OTXXLButton(
                buttonTitle: Constants.Text.confirmButtonTitle,
                action: {
                    self.appPathManager.pop(count: 2)
                },
                isClickable: true
            )
            .padding(.horizontal, 16)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    OneThingMatchingFailView(
        appPathManager: .constant(OTAppPathManager()),
        viewModel: .constant(OneThingMatchingViewModel())
    )
}

