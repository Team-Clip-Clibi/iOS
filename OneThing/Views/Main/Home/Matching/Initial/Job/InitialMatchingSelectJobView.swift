//
//  InitialMatchingSelectJobView.swift
//  OneThing
//
//  Created by 오현식 on 5/21/25.
//

import SwiftUI

struct InitialMatchingSelectJobView: View {
    
    enum Constants {
        enum Text {
            static let naviTitle = "모임 신청"
            
            static let title = "현재 하고 계신 일을\n선택해주세요"
            static let subTitle = "최대 1개까지 선택할 수 있어요."
            
            static let nextButtonTitle = "다음"
        }
        
        static let progress = 1.0 / 3.0
    }
    
    @Environment(\.homeCoordinator) var homeCoordinator
    
    @Binding var store: InitialMatchingStore
    
    @State private var isNextButtonEnabled: Bool = false
    @State private var selectedJobs: [JobType] = []
    
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
                
                MultipleOnlyTextBoxView<JobType>(
                    state: .init(
                        items: JobType.allCases.map { .init(item: $0) },
                        selectionLimit: 1,
                        changeWhenIsReachedLimit: true
                    ),
                    isReachedLimit: .constant(false),
                    isSelected: $isNextButtonEnabled,
                    selectedItems: $selectedJobs,
                    cols: [GridItem(), GridItem()],
                    alignment: .center
                )
                .onChange(of: self.selectedJobs) { _, new in
                    guard let selectedJob = new.last else { return }
                    Task { await self.store.send(.updateSelectedJob(selectedJob)) }
                }
                
                Spacer()
                
                BottomButton(
                    isClickable: $isNextButtonEnabled,
                    title: Constants.Text.nextButtonTitle,
                    buttonTapAction: { self.homeCoordinator.push(to: .home(.initial(.dietary))) }
                )
            }
        }
        .navigationBar(
            title: Constants.Text.title,
            hidesBottomSeparator: true,
            onBackButtonTap: {
                Task { await self.store.send(.updateSelectedJob(nil)) }
                self.homeCoordinator.pop()
            }
        )
    }
}

#Preview {
    let initialMatchingStoreForPreview = InitialMatchingStore(
        willPushedMatchingType: .onething,
        updateJobUseCase: UpdateJobUseCase(),
        updateDietaryUseCase: UpdateDietaryUseCase(),
        updateLanguageUseCase: UpdateLanguageUseCase()
    )
    InitialMatchingSelectJobView(store: .constant(initialMatchingStoreForPreview))
}
