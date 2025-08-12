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
        
        static let message = "질문이 인연이 되는 월요일\n함께할래요?"
        
        static let nextButtonTitle = "다음"
    }
    
    @Environment(\.homeCoordinator) var homeCoordinator
    
    @Binding var store: RandomMatchingStore
    
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
                        
                        Image(.randomMatchingMain)
                    }
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity)
                    .frame(height: 460)
                }
                
                Spacer()
                
                BottomButton(
                    isClickable: .constant(true),
                    title: ConstText.nextButtonTitle,
                    buttonTapAction: { self.homeCoordinator.push(to: .home(.random(.location))) }
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
    RandomMatchingMainView(store: .constant(RandomMatchingStore()))
}
