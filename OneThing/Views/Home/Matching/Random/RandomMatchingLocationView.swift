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
    
    @Binding var appPathManager: OTAppPathManager
    @Binding var viewModel: RandomMatchingViewModel
    
    @State private var isReachedLimit: Bool = false
    @State private var isNextButtonEnabled: Bool = false
    
    // TODO: Preview 용
    private let locations = ["홍대/합정", "강남", "여의도/영등포", "요산/영등포", "건대/성수"]
    
    var body: some View {
        
        VStack {
            
            NavigationBar()
                .title(Constants.Text.naviTitle)
                .hidesBottomSeparator(true)
                .onBackButtonTap {
                    self.viewModel.currentState.selectedLocations.removeAll()
                    self.appPathManager.pop()
                }
            
            LinerProgressView(value: Constants.progress, shape: Rectangle())
                .tint(.purple400)
            
            Spacer().frame(height: 32)
            
            Text(Constants.Text.title)
                .otFont(.heading2)
                .multilineTextAlignment(.leading)
                .foregroundStyle(.gray800)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer().frame(height: 2)
            
            Text(Constants.Text.subTitle)
                .otFont(.subtitle2)
                .multilineTextAlignment(.leading)
                .foregroundStyle(self.isReachedLimit ? .red100: .gray600)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer().frame(height: 24)
            
            MultipleCheckBoxView(
                state: SelectionState(
                    items: self.locations.map { SelectionItem(title: $0) },
                    selectLimit: 2
                ),
                isReachedLimit: $isReachedLimit,
                isSelected: $isNextButtonEnabled,
                selectedTitles: $viewModel.currentState.selectedLocations
            )
            
            Spacer()
            
            Rectangle()
                .frame(width: nil, height: 1)
                .foregroundStyle(.gray200)
            
            Spacer().frame(height: 8)
            
            OTXXLButton(
                buttonTitle: Constants.Text.nextButtonTitle,
                action: {
                    self.appPathManager.push(path: .random(.topic))
                },
                isClickable: self.isNextButtonEnabled
            )
            .padding(.horizontal, 16)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    RandomMatchingLocationView(
        appPathManager: .constant(OTAppPathManager()),
        viewModel: .constant(RandomMatchingViewModel())
    )
}
