//
//  OnethingMatchingFailView.swift
//  OneThing
//
//  Created by 윤동주 on 6/29/25.
//


import SwiftUI

struct OnethingMatchingFailView: View {
    
    enum Constants {
        enum Text {
            static let naviTitle = "원띵 모임 신청"
            
            static let title = "결제에 실패했어요"
            static let subTitle = "일시적인 오류로 결제가 중단되었어요\n잠시 후 다시 시도해 주세요"
            
            static let confirmButtonTitle = "확인"
        }
    }
    
    @Environment(\.homeCoordinator) var homeCoordinator
    
    @Binding var store: OnethingMatchingStore
    
    var body: some View {
        
        OTBaseView(String(describing: Self.self)) {
            
            VStack {
                
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
                    action: { self.homeCoordinator.popToRoot() },
                    isClickable: true
                )
                .padding(.horizontal, 16)
            }
        }
        .navigationBar(
            title: Constants.Text.naviTitle,
            hidesBackButton: true,
            hidesBottomSeparator: false,
            rightButtons: [
                AnyView(
                    Button {
                        self.homeCoordinator.popToRoot()
                     } label: {
                         Image(.closeOutlined)
                             .resizable()
                             .frame(width: 24, height: 24)
                             .foregroundStyle(.gray500)
                     }
                )
            ]
        )
    }
}

#Preview {
    let onethingMatchingStoreForPreview = OnethingMatchingStore(
        submitOnethingsOrderUseCase: SubmitOnethingsOrderUseCase(),
        submitPaymentsConfirmUseCase: SubmitPaymentsConfirmUseCase()
    )
    OnethingMatchingFailView(store: .constant(onethingMatchingStoreForPreview))
}

