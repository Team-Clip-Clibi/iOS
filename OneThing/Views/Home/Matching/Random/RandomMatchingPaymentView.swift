//
//  RandomMatchingPaymentView.swift
//  OneThing
//
//  Created by 오현식 on 5/15/25.
//

import SwiftUI

struct RandomMatchingPaymentView: View {
    
    enum Constants {
        enum Text {
            static let naviTitle = "랜덤 모임 신청"
            
            static let title = "당신을 위한 모임 준비되었어요"
            static let subTitle = "아래 내용을 확인하고, 결제하시면 신청이 완료됩니다."
            
            static let eventTitle = "원띵 출시 이벤트"
            static let eventSubTitle = "지금, 매칭비용은 단 2,900원이에요."
            
            static let contentTitle = "에게 매칭된 이번주 모임"
            static let contentDateTitle = "일시"
            static let contentLocationTitle = "장소"
            
            static let alertTitle = "토스 앱이 없다면, 설치 후 결제를 진행해주세요."
            static let alertMessage = "토스 앱이 없다면, 설치 후 결제를 진행해주세요."
            static let alertConfirmButtonTitle = "확인"
            
            static let paymentButtonTitle = "신청 완료"
        }
        
        static let progress = 2.0 / 3.0
        static let maxCharacters = 50
    }
    
    @Binding var appPathManager: OTAppPathManager
    @Binding var viewModel: RandomMatchingViewModel
    
    @State var isRequestPaymentAlert: Bool = false
    
    var body: some View {
            
        VStack {
            
            NavigationBar()
                .title(Constants.Text.naviTitle)
                .hidesBottomSeparator(true)
                .onBackButtonTap { self.appPathManager.pop() }
            
            ZStack {
                Color.gray100.ignoresSafeArea()
                
                VStack {
                    Spacer().frame(height: 32)
                    
                    GuideMessageView(
                        isChangeSubTitleColor: .constant(false),
                        title: Constants.Text.title,
                        subTitle: Constants.Text.subTitle
                    )
                    
                    Spacer().frame(height: 32)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white100)
                        
                        HStack(spacing: 12) {
                            Image(.discount)
                                .resizable()
                                .frame(width: 36, height: 36)
                                .padding(.leading, 16)
                                
                            
                            VStack(spacing: 2) {
                                Text(Constants.Text.eventTitle)
                                    .otFont(.caption1)
                                    .foregroundStyle(.purple400)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(Constants.Text.eventSubTitle)
                                    .otFont(.subtitle2)
                                    .foregroundStyle(.gray800)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity)
                    .frame(height: 68)
                    
                    Spacer().frame(height: 12)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white100)
                        
                        VStack {
                            Text(Constants.Text.contentTitle)
                                .otFont(.subtitle2)
                                .foregroundStyle(.gray800)
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            Spacer().frame(height: 20)
                            
                            HStack {
                                Image(.clockFill)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.purple400)
                                
                                Spacer().frame(width: 8)
                                
                                Text(Constants.Text.contentDateTitle)
                                    .otFont(.subtitle2)
                                    .foregroundStyle(.gray800)
                                
                                Spacer()
                                
                                Text("2025.03.09(일), 18:00")
                                    .otFont(.subtitle2)
                                    .foregroundStyle(.gray800)
                            }
                            
                            Spacer().frame(height: 10)
                            
                            Rectangle()
                                .fill(.gray200)
                                .frame(height: 1)
                            
                            HStack {
                                Image(.locationFill)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.purple400)
                                
                                Spacer().frame(width: 8)
                                
                                Text(Constants.Text.contentLocationTitle)
                                    .otFont(.subtitle2)
                                    .foregroundStyle(.gray800)
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("종각역 한옥마루")
                                        .otFont(.subtitle2)
                                        .foregroundStyle(.gray800)
                                    
                                    Text("(서울 종로구 창덕궁길 152)")
                                        .otFont(.subtitle2)
                                        .foregroundStyle(.gray800)
                                }
                            }
                                
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity)
                    .frame(height: 179)
                    
                    Spacer()
                    
                    BottomButton(
                        isClickable: .constant(true),
                        title: Constants.Text.paymentButtonTitle,
                        buttonTapAction: {
                            self.isRequestPaymentAlert = true
                        }
                    )
                }
            }
        }
        .navigationBarBackButtonHidden()
        .showAlert(
            isPresented: $isRequestPaymentAlert,
            title: Constants.Text.alertTitle,
            message: Constants.Text.alertMessage,
            actions: [
                AlertAction(
                    title: Constants.Text.alertConfirmButtonTitle,
                    style: .primary,
                    action: { }
                )
            ],
            dismissWhenBackgroundTapped: true
        )
    }
}

#Preview {
    RandomMatchingPaymentView(
        appPathManager: .constant(OTAppPathManager()),
        viewModel: .constant(RandomMatchingViewModel())
    )
}
