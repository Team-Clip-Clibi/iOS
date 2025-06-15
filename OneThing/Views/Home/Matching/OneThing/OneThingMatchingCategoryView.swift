//
//  OneThingMatchingCategoryView.swift
//  OneThing
//
//  Created by 오현식 on 5/27/25.
//

import SwiftUI

struct OneThingMatchingCategoryView: View {
    
    enum Constants {
        enum Text {
            static let naviTitle = "원띵 모임 신청"
            
            static let title = "원띵 모임의 카테고리를\n선택해주세요"
            static let subTitle = "나누고 싶은 대화 주제의 카테고리를 선택해주세요"
            
            static let nextButtonTitle = "다음"
        }
        
        static let progress = 1.0 / 6.0
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
                    self.viewModel.initializeState(.category)
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
            
            MultipleTextWithImageBoxView<OneThingCategory>(
                viewType: .matching,
                matrixs: [GridItem(), GridItem(), GridItem()],
                state: .init(
                    items: OneThingCategory.allCases.map { .init(item: $0) },
                    selectLimit: 1
                ),
                isReachedLimit: $isReachedLimit,
                isSelected: $isNextButtonEnabled,
                selectedItems: $viewModel.currentState.selectedCategory
            )
            
            Spacer()
            
            BottomButton(
                isClickable: $isNextButtonEnabled,
                title: Constants.Text.nextButtonTitle,
                buttonTapAction: { self.appPathManager.push(path: .oneThing(.topic)) }
            )
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    OneThingMatchingCategoryView(
        appPathManager: .constant(OTAppPathManager()),
        viewModel: .constant(OneThingMatchingViewModel())
    )
}
