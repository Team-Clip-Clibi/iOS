//
//  MyPageEditJobView.swift
//  OneThing
//
//  Created by 윤동주 on 4/24/25.
//

import SwiftUI

struct MyPageEditJobView: View {
    
    @Environment(\.myPageCoordinator) var myPageCoordinator
    
    @Binding var store: MyPageEditStore
    
    @State private var isLimitErrorHighlighted = false
    @State private var shakeTrigger: CGFloat = 0
    @State private var job: JobType?
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private let maxSelection = 2
    
    var body: some View {
        
        OTBaseView(String(describing: Self.self)) {
            
            VStack {
                
                Spacer().frame(height: 32)
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(JobType.allCases) { job in
                        OTSelectionButton(buttonTitle: job.toKorean, action: {
                            toggle(job)
                        }, isClicked: self.job == job)
                    }
                }
                .padding(.horizontal, 16)
                
                Spacer()
                
                Rectangle()
                    .fill(.gray200)
                    .frame(height: 1)
                
                OTXXLButton(
                    buttonTitle: "완료",
                    action: {
                        Task {
                            await self.store.send(.updateJob(self.job))
                        }
                    },
                    isClickable: self.job != nil
                )
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .onChange(of: self.store.state.isJobUpdated) { _, newValue in
                    if newValue { self.myPageCoordinator.dismissCover() }
                }
            }
            .taskForOnce { await self.store.send(.job) }
            .onChange(of: self.store.state.job) { _, newValue in
                self.job = newValue
            }
        }
        .navigationBar(
            title: "하는 일 변경",
            hidesBackButton: true,
            hidesBottomSeparator: false,
            rightButtons: [
                AnyView(
                    Button(
                        action: { self.myPageCoordinator.dismissCover() },
                        label: {
                            Image(.closeOutlined)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.gray500)
                        }
                    )
                )
            ]
        )
    }
    
    private func toggle(_ job: JobType) {
        self.job = job
    }
}

#Preview {
    let myPageEditStoreForPreview = MyPageEditStore(
        socialLoginUseCase: SocialLoginUseCase(),
        
        getProfileInfoUseCase: GetProfileInfoUseCase(),
        getJobUseCase: GetJobUseCase(),
        getRelationshipUseCase: GetRelationshipUseCase(),
        getDietaryUseCase: GetDietaryUseCase(),
        getLanguageUseCase: GetLanguageUseCase(),
        getNicknameAvailableUseCase: GetNicknameAvailableUseCase(),
        
        updateNicknameUseCase: UpdateNicknameUseCase(),
        updateJobUseCase: UpdateJobUseCase(),
        updateRelationshipUseCase: UpdateRelationshipUseCase(),
        updateDietaryUseCase: UpdateDietaryUseCase(),
        updateLanguageUseCase: UpdateLanguageUseCase()
    )
    MyPageEditJobView(store: .constant(myPageEditStoreForPreview))
}
