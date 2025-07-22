//
//  InMeetingMainView.swift
//  OneThing
//
//  Created by 오현식 on 6/2/25.
//

import SwiftUI

struct InMeetingMainView: View {
    
    enum Constants {
        enum Text {
            static let title = "모임시작"
            static let subTitle = "인사는 나누셨나요?"
            static let message = "원하는 메뉴를 주문하고, 각자 닉네임으로 소개한 후 모임을 진행해 주세요"
            
            static let startMeetingButtonTitle = "모임 시작하기"
        }
    }
    
    @Binding var inMeetingPathManager: OTInMeetingPathManager
    @Binding var viewModel: InMeetingViewModel
    
    var body: some View {
        
        VStack {
            InMeetingGuideMessageView(
                title: Constants.Text.title,
                subTitle: Constants.Text.subTitle,
                message: Constants.Text.message
            )
            
            Spacer().frame(height: 32)
            
            ScrollView(.vertical, showsIndicators: false) {
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.purple100)
                    
                    VStack(spacing: 32) {
                        Image(.inMeetingMain)
                            .resizable()
                            .frame(width: 267, height: 223)
                        
                        Text("두 줄\n멘트")
                            .otFont(.title1)
                            .foregroundStyle(.gray800)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity)
                .frame(height: 460)
            }
            
            Spacer()
            
            OTXXLButton(
                buttonTitle: Constants.Text.startMeetingButtonTitle,
                action: { self.inMeetingPathManager.push(path: .selectHost) },
                isClickable: true
            )
            .padding(.bottom, 12)
            .padding(.horizontal, 24)
        }
        .navigationBarBackButtonHidden()
        .task {
            await self.viewModel.matchingProgress()
        }
    }
}

#Preview {
    InMeetingMainView(
        inMeetingPathManager: .constant(OTInMeetingPathManager()),
        viewModel: .constant(InMeetingViewModel(matchingId: "", matchingType: .onething))
    )
}
