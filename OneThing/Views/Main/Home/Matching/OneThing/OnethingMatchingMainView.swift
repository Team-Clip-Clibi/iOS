//
//  OneThingMatchingMainView.swift
//  OneThing
//
//  Created by 오현식 on 5/27/25.
//

import SwiftUI

struct OnethingMatchingMainView: View {
    
    enum ConstText {
        
        static let naviTitle = "원띵 모임 신청"
        
        static let title = "매주 토, 일\n원띵 모임에서 만나요"
        static let subTitle = "대화 주제가 맞는 사람과 만나 ‘Onething’을 나눠요"
        
        static let message = "관심있는 하나의 주제로,\n집중적으로 대화해요"
        
        static let nextButtonTitle = "다음"
    }
    
    @Environment(\.homeCoordinator) var homeCoordinator
    
    @Binding var store: OnethingMatchingStore
    
    var body: some View {
        
        OTBaseView(String(describing: Self.self)) {
            
            VStack {
                
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
                        
                        Image(.onethingMatchingMain)
                    }
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity)
                    .frame(height: 460)
                }
                
                Spacer()
                
                BottomButton(
                    isClickable: .constant(true),
                    title: ConstText.nextButtonTitle,
                    buttonTapAction: { self.homeCoordinator.push(to: .home(.onething(.category))) }
                )
            }
        }
        .navigationBar(
            title: ConstText.naviTitle,
            hidesBottomSeparator: true,
            onBackButtonTap: { self.homeCoordinator.pop() }
        )
    }
}

#Preview {
    let onethingMatchingStoreForPreview = OnethingMatchingStore(
        submitOnethingsOrderUseCase: SubmitOnethingsOrderUseCase(),
        submitPaymentsConfirmUseCase: SubmitPaymentsConfirmUseCase()
    )
    OnethingMatchingMainView(store: .constant(onethingMatchingStoreForPreview))
}
