//
//  OneThingMatchingPaymentView.swift
//  OneThing
//
//  Created by 오현식 on 5/27/25.
//

import SwiftUI
import TossPayments

enum PaymentResult: Identifiable, Equatable {
    case success(TossPaymentsResult.Success)
    case failure(TossPaymentsResult.Fail)
    case apiFailure
    
    var id: String {
        switch self {
        case .success(let s): return "success_\(s.paymentKey)"
        case .failure(let f): return "fail_\(f.errorCode)"
        case .apiFailure: return "Payment API failure"
        }
    }
}

struct OneThingMatchingPaymentView: View {
    
    enum Constants {
        enum Text {
            static let naviTitle = "원띵 모임 신청"
            
            static let title = "당신을 위한 모임 준비되었어요"
            static let subTitle = "아래 내용을 확인하고, 결제하시면 신청이 완료됩니다."
            
            static let eventTitle = "원띵 출시 이벤트"
            static let eventSubTitle = "지금, 매칭비용은 단 2,900원이에요."
            
            static let alertTitle = "원띵은 토스페이 결제만 가능해요"
            static let alertMessage = "토스 앱이 없다면, 설치 후 결제를 진행해주세요"
            static let alertConfirmButtonTitle = "확인"
            
            static let paymentButtonTitle = "결제하고 참여하기"
        }
    }
    
    @Binding var appPathManager: OTAppPathManager
    @Binding var viewModel: OneThingMatchingViewModel
    
    @State var isRequestPaymentAlert: Bool = false
    @State private var isTossPaymentSheetShown: Bool = false
    @State private var paymentResult: PaymentResult?
    
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
                
                    Spacer()
                    
                    BottomButton(
                        isClickable: .constant(true),
                        title: Constants.Text.paymentButtonTitle,
                        buttonTapAction: { self.isRequestPaymentAlert = true }
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
                    action: {
                        self.isRequestPaymentAlert = false
                        self.isTossPaymentSheetShown.toggle()
                    }
                )
            ],
            dismissWhenBackgroundTapped: true
        )
        .fullScreenCover(isPresented: $isTossPaymentSheetShown) {
            TossPaymentsView(isShowingFullScreen: $isTossPaymentSheetShown,
                             paymentResult: $paymentResult,
                             oneThingMatchingViewModel: $viewModel)
        }
        .onChange(of: paymentResult) { _, newValue in
            self.isTossPaymentSheetShown.toggle()
            if let result = newValue, case .success = result {
                self.appPathManager.homePaths.append(.onething(.paySuccess))
            } else {
                self.appPathManager.homePaths.append(.onething(.payFail))
            }
        }
    }
}

#Preview {
    OneThingMatchingPaymentView(
        appPathManager: .constant(OTAppPathManager()),
        viewModel: .constant(OneThingMatchingViewModel())
    )
}
