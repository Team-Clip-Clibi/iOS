//
//  OneThingMatchingLocationView.swift
//  OneThing
//
//  Created by 오현식 on 5/27/25.
//

import SwiftUI

struct OneThingMatchingLocationView: View {
    
    enum Constants {
        enum Text {
            static let naviTitle = "원띵 모임 신청"
            
            static let title = "이번 랜덤 모임을 하고싶은\n지역을 선택해주세요"
            static let subTitle = "최대 2개까지 선택할 수 있어요."
            
            static let nextButtonTitle = "다음"
        }
        
        static let progress = 3.0 / 6.0
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
                    self.viewModel.initializeState(.location)
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
            
            
            MultipleCheckBoxView<District>(
                viewType: .matching,
                state: .init(
                    items: District.allCases.map { .init(item: $0) },
                    selectionLimit: 2
                ),
                isReachedLimit: $isReachedLimit,
                isSelected: $isNextButtonEnabled,
                selectedItems: $viewModel.currentState.selectedDistrict
            )
            
            Spacer()
            
            BottomButton(
                isClickable: $isNextButtonEnabled,
                title: Constants.Text.nextButtonTitle,
                buttonTapAction: { self.appPathManager.push(path: .onething(.price)) }
            )
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    OneThingMatchingLocationView(
        appPathManager: .constant(OTAppPathManager()),
        viewModel: .constant(OneThingMatchingViewModel())
    )
}
