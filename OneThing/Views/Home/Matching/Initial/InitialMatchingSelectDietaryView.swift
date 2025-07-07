//
//  InitialMatchingSelectDietaryView.swift
//  OneThing
//
//  Created by 오현식 on 5/24/25.
//

import SwiftUI

struct InitialMatchingSelectDietaryView: View {
    
    enum Constants {
        enum Text {
            static let naviTitle = "모임 신청"
            
            static let title = "식사 메뉴 선정 시 참고할 점을 알려주세요"
            static let subTitle = "알레르기나 특별한 식사 취향이 있다면 말씀해 주세요"
            
            static let etcPlaceholder = "ex. 갑각류 알레르기가 있어요, 매운 음식을 못먹어요"
            
            static let nextButtonTitle = "다음"
        }
        
        static let progress = 2.0 / 3.0
    }
    
    @Binding var appPathManager: OTAppPathManager
    @Binding var viewModel: InitialMatchingViewModel
    
    @State private var isNextButtonEnabled: Bool = false
    
    var body: some View {
        
        VStack {
            
            NavigationBar()
                .title(Constants.Text.naviTitle)
                .hidesBottomSeparator(true)
                .onBackButtonTap {
                    self.viewModel.initializeState(.dietary)
                    self.appPathManager.pop()
                }
            
            LinerProgressView(value: Constants.progress, shape: Rectangle())
                .tint(.purple400)
            
            Spacer().frame(height: 32)
            
            GuideMessageView(
                isChangeSubTitleColor: .constant(false),
                title: Constants.Text.title,
                subTitle: Constants.Text.subTitle
            )
            
            Spacer().frame(height: 24)
            
            VStack(spacing: 14) {
                
                MultipleOnlyTextBoxView<DietaryType>(
                    state: .init(
                        items: DietaryType.allCases.map { .init(item: $0) },
                        selectionLimit: 1,
                        changeWhenIsReachedLimit: true
                    ),
                    isReachedLimit: .constant(false),
                    isSelected: $isNextButtonEnabled,
                    selectedItems: $viewModel.currentState.selectedDietaries,
                    cols: [GridItem()],
                    alignment: .leading
                )
                /// cell height + spacing + inset
                .frame(height: 48 * 5 + 10 * 4 + 10)
                
                if self.viewModel.currentState.selectedDietaries.first == DietaryType.etc {
                    VStack(spacing: 24) {
                        Rectangle()
                            .fill(.gray200)
                            .frame(height: 1)
                        
                        TextField(
                            Constants.Text.etcPlaceholder,
                            text: $viewModel.currentState.dietaryWithContents
                        )
                            .tint(.purple400)
                            .frame(height: 48)
                            .overlay(
                                Rectangle()
                                    .frame(width: nil, height: 1, alignment: .bottom)
                                    .foregroundStyle(.gray500),
                                alignment: .bottom
                            )
                    }
                    .padding(.horizontal, 16)
                } else {
                    EmptyView()
                }
            }
            
            Spacer()
            
            BottomButton(
                isClickable: $isNextButtonEnabled,
                title: Constants.Text.nextButtonTitle,
                buttonTapAction: { self.appPathManager.push(path: .initial(.language)) }
            )
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    InitialMatchingSelectDietaryView(
        appPathManager: .constant(OTAppPathManager()),
        viewModel: .constant(InitialMatchingViewModel())
    )
}
