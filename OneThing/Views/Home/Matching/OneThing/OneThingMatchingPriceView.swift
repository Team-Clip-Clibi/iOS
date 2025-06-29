//
//  OneThingMatchingPriceView.swift
//  OneThing
//
//  Created by 오현식 on 5/27/25.
//

import SwiftUI

struct OneThingMatchingPriceView: View {
    
    enum Constants {
        enum Text {
            static let naviTitle = "원띵 모임 신청"
            
            static let title = "식사에 사용하고 싶은 금액을\n선택해주세요"
            static let subTitle = "선택하신 금액은 식당 선정 시에 참고할게요"
            
            static let nextButtonTitle = "다음"
        }
        
        static let progress = 4.0 / 6.0
    }
    
    @Binding var appPathManager: OTAppPathManager
    @Binding var viewModel: OneThingMatchingViewModel
    
    @State private var isReachedLimit: Bool = false
    @State private var isNextButtonEnabled: Bool = false
    
    var body: some View {
        
        VStack {
            
            NavigationBar()
                .title(Constants.Text.naviTitle)
                .hidesBottomSeparator(true)
                .onBackButtonTap {
                    self.viewModel.initializeState(.price)
                    self.appPathManager.pop()
                }
            
            LinerProgressView(value: Constants.progress, shape: Rectangle())
                .tint(.purple400)
            
            Spacer().frame(height: 32)
            
            GuideMessageView(
                isChangeSubTitleColor: $isReachedLimit,
                title: Constants.Text.title,
                subTitle: Constants.Text.subTitle
            )
            
            Spacer().frame(height: 24)
            
            MultipleCheckBoxView(
                viewType: .matching,
                state: .init(
                    items: self.viewModel.prices.map { .init(title: $0) },
                    selectLimit: 1
                ),
                isReachedLimit: $isReachedLimit,
                isSelected: $isNextButtonEnabled,
                selectedTitles: $viewModel.currentState.selectedPrices
            )
            
            Spacer()
            
            BottomButton(
                isClickable: $isNextButtonEnabled,
                title: Constants.Text.nextButtonTitle,
                buttonTapAction: { self.appPathManager.push(path: .onething(.tmi)) }
            )
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    OneThingMatchingPriceView(
        appPathManager: .constant(OTAppPathManager()),
        viewModel: .constant(OneThingMatchingViewModel())
    )
}
