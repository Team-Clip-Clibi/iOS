//
//  OnethingMatchingCompleteView.swift
//  OneThing
//
//  Created by 오현식 on 5/27/25.
//

import SwiftUI

struct OnethingMatchingCompleteView: View {
    
    enum Constants {
        enum Text {
            static let naviTitle = "원띵 모임 신청"
            
            static let title = "모임 신청이 완료되었어요"
            static let subTitle = "신청한 모임은 ‘내 모임-모임 내역’에서 확인할 수 있어요"
            
            static let goMeetingDetailsButtonTitle = "모임 내역 보기"
            static let goHomeButtonTitle = "홈으로 돌아가기"
        }
    }
    
    @Environment(\.homeCoordinator) var homeCoordinator
    
    @Binding var store: OnethingMatchingStore
    
    var body: some View {
        
        OTBaseView(String(describing: Self.self)) {
            
            VStack {
                
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
                
                Image(.success)
                
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
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.purple400, lineWidth: 1)
                    )
                    .clipShape(.rect(cornerRadius: 12))
                    
                    OTXXLButton(
                        buttonTitle: Constants.Text.goHomeButtonTitle,
                        action: {
                            NotificationCenter.default.post(
                                name: .fetchMatchingsForToday,
                                object: nil
                            )
                            
                            self.homeCoordinator.popToRoot()
                        },
                        isClickable: true
                    )
                }
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
                        NotificationCenter.default.post(
                            name: .fetchMatchingsForToday,
                            object: nil
                        )
                        
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
    OnethingMatchingCompleteView(store: .constant(onethingMatchingStoreForPreview))
}
