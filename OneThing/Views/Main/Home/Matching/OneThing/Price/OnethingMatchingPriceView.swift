//
//  OnethingMatchingPriceView.swift
//  OneThing
//
//  Created by 오현식 on 5/27/25.
//

import SwiftUI

struct OnethingMatchingPriceView: View {
    
    enum Constants {
        enum Text {
            static let naviTitle = "원띵 모임 신청"
            
            static let title = "식사에 사용하고 싶은 금액을\n선택해주세요"
            static let subTitle = "선택하신 금액은 식당 선정 시에 참고할게요"
            
            static let nextButtonTitle = "다음"
        }
        
        static let progress = 4.0 / 6.0
    }
    
    @Environment(\.homeCoordinator) var homeCoordinator
    
    @Binding var store: OnethingMatchingStore
    
    @State private var isNextButtonEnabled: Bool = false
    @State private var selectedBudgetRanges: [BudgetRange] = []
    
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
                
                MultipleCheckBoxView<BudgetRange>(
                    viewType: .matching,
                    state: .init(
                        items: BudgetRange.allCases.map { .init(item: $0) },
                        selectionLimit: 1,
                        changeWhenIsReachedLimit: true
                    ),
                    isReachedLimit: .constant(false),
                    isSelected: $isNextButtonEnabled,
                    selectedItems: $selectedBudgetRanges
                )
                .onChange(of: self.selectedBudgetRanges) { _, new in
                    guard let selectedBudgetRange = new.last else { return }
                    Task { await self.store.send(.updateBudgetRange(selectedBudgetRange)) }
                }
                
                Spacer()
                
                BottomButton(
                    isClickable: $isNextButtonEnabled,
                    title: Constants.Text.nextButtonTitle,
                    buttonTapAction: { self.homeCoordinator.push(to: .home(.onething(.tmi))) }
                )
            }
        }
        .navigationBar(
            title: Constants.Text.naviTitle,
            hidesBottomSeparator: true,
            onBackButtonTap: {
                Task { await self.store.send(.updateBudgetRange(nil)) }
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
    OnethingMatchingPriceView(store: .constant(onethingMatchingStoreForPreview))
}
