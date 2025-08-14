//
//  RandomMatchingLocationView.swift
//  OneThing
//
//  Created by 오현식 on 5/15/25.
//

import SwiftUI

struct RandomMatchingLocationView: View {
    
    enum Constants {
        enum Text {
            static let naviTitle = "랜덤 모임 신청"
            
            static let title = "이번 랜덤 모임을 하고싶은\n지역을 선택해주세요"
            static let subTitle = "최대 2개까지 선택할 수 있어요."
            
            static let nextButtonTitle = "다음"
        }
        
        static let progress = 1.0 / 3.0
    }
    
    @Environment(\.homeCoordinator) var homeCoordinator
    
    @Binding var store: RandomMatchingStore
    
    @State private var isNextButtonEnabled: Bool = false
    @State private var selectedDistricts: [District] = []
    
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
                
                MultipleCheckBoxView<District>(
                    viewType: .matching,
                    state: .init(
                        items: District.allCases.map { .init(item: $0) },
                        selectionLimit: 2
                    ),
                    isReachedLimit: .constant(false),
                    isSelected: $isNextButtonEnabled,
                    selectedItems: $selectedDistricts
                )
                .onChange(of: self.selectedDistricts.last) { _, new in
                    Task { await self.store.send(.updateDistrict(new)) }
                }
                
                Spacer()
                
                BottomButton(
                    isClickable: $isNextButtonEnabled,
                    title: Constants.Text.nextButtonTitle,
                    buttonTapAction: { self.homeCoordinator.push(to: .home(.random(.topic))) }
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
    RandomMatchingLocationView(store: .constant(RandomMatchingStore(with: "현식")))
}
