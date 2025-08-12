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
    
    @Environment(\.homeCoordinator) var homeCoordinator
    
    @Binding var store: InitialMatchingStore
    
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
                        
                        VStack(spacing: 32) {
                            Image(.initialMatchingMain)
                            
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
                    buttonTapAction: { self.homeCoordinator.push(to: .home(.initial(.job))) }
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
    let initialMatchingStoreForPreview = InitialMatchingStore(
        willPushedMatchingType: .onething,
        updateJobUseCase: UpdateJobUseCase(),
        updateDietaryUseCase: UpdateDietaryUseCase(),
        updateLanguageUseCase: UpdateLanguageUseCase()
    )
    InitialMatchingMainView(store: .constant(initialMatchingStoreForPreview))
}
