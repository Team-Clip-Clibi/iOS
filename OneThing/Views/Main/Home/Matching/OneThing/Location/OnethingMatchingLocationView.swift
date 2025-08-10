//
//  OnethingMatchingLocationView.swift
//  OneThing
//
//  Created by 오현식 on 5/27/25.
//

import SwiftUI

struct OnethingMatchingLocationView: View {
    
    enum Constants {
        enum Text {
            static let naviTitle = "원띵 모임 신청"
            
            static let title = "이번 랜덤 모임을 하고싶은\n지역을 선택해주세요"
            static let subTitle = "최대 2개까지 선택할 수 있어요."
            
            static let nextButtonTitle = "다음"
        }
        
        static let progress = 3.0 / 6.0
    }
    
    @Environment(\.homeCoordinator) var homeCoordinator
    
    @Binding var store: OnethingMatchingStore
    
    @State private var isReachedLimit: Bool = false
    @State private var isNextButtonEnabled: Bool = false
    @State private var selectedDistricts: [District] = []
    
    var body: some View {
        
        OTBaseView(String(describing: Self.self)) {
            
            VStack {
                
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
                    selectedItems: $selectedDistricts
                )
                .onChange(of: self.selectedDistricts) { _, new in
                    guard let selectedDistrict = new.last else { return }
                    Task { await self.store.send(.updateDistrict(selectedDistrict)) }
                }
                
                Spacer()
                
                BottomButton(
                    isClickable: $isNextButtonEnabled,
                    title: Constants.Text.nextButtonTitle,
                    buttonTapAction: { self.homeCoordinator.push(to: .home(.onething(.price))) }
                )
            }
        }
        .navigationBar(
            title: Constants.Text.naviTitle,
            hidesBottomSeparator: true,
            onBackButtonTap: {
                Task { await self.store.send(.updateDistrict(nil)) }
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
    OnethingMatchingLocationView(store: .constant(onethingMatchingStoreForPreview))
}
