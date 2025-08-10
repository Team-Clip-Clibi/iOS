//
//  OneThingMatchingCategoryView.swift
//  OneThing
//
//  Created by 오현식 on 5/27/25.
//

import SwiftUI

struct OnethingMatchingCategoryView: View {
    
    enum Constants {
        enum Text {
            static let naviTitle = "원띵 모임 신청"
            
            static let title = "원띵 모임의 카테고리를\n선택해주세요"
            static let subTitle = "나누고 싶은 대화 주제의 카테고리를 선택해주세요"
            
            static let nextButtonTitle = "다음"
        }
        
        static let progress = 1.0 / 6.0
    }
    
    @Environment(\.homeCoordinator) var homeCoordinator
    
    @Binding var store: OnethingMatchingStore
    
    @State private var isNextButtonEnabled: Bool = false
    @State private var selectedCategories: [OneThingCategory] = []
    
    var body: some View {
        
        OTBaseView(String(describing: Self.self)) {
            
            VStack {
                
                LinerProgressView(value: Constants.progress, shape: Rectangle())
                    .tint(.purple400)
                
                Spacer().frame(height: 32)
                
                GuideMessageView(
                    isChangeSubTitleColor: .constant(false),
                    title: Constants.Text.title,
                    subTitle: Constants.Text.subTitle
                )
                
                Spacer().frame(height: 24)
                
                MultipleTextWithImageBoxView<OneThingCategory>(
                    viewType: .matching,
                    matrixs: [GridItem(), GridItem(), GridItem()],
                    state: .init(
                        items: OneThingCategory.allCases.map { .init(item: $0) },
                        selectionLimit: 1,
                        changeWhenIsReachedLimit: true
                    ),
                    isReachedLimit: .constant(false),
                    isSelected: $isNextButtonEnabled,
                    selectedItems: $selectedCategories
                )
                .onChange(of: self.selectedCategories) { _, new in
                    guard let selectedCategory = self.selectedCategories.last else { return }
                    Task { await self.store.send(.updateCategory(selectedCategory)) }
                }
                
                Spacer()
                
                BottomButton(
                    isClickable: $isNextButtonEnabled,
                    title: Constants.Text.nextButtonTitle,
                    buttonTapAction: { self.homeCoordinator.push(to: .home(.onething(.topic))) }
                )
            }
        }
        .navigationBar(
            title: Constants.Text.naviTitle,
            hidesBottomSeparator: true,
            onBackButtonTap: {
                Task { await self.store.send(.updateCategory(nil)) }
                self.homeCoordinator.pop()
            }
        )
    }
}

#Preview {
    let onethingMatchingStoreForPreview = OnethingMatchingStore(
        submitOnethingsOrderUseCase: SubmitOnethingsOrderUseCase(),
        submitPaymentsConfirmUseCase: SubmitPaymentsConfirmUseCase()
    )
    OnethingMatchingCategoryView(store: .constant(onethingMatchingStoreForPreview))
}
