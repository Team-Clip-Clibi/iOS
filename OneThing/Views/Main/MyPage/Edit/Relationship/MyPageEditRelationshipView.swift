//
//  MyPageEditRelationshipView.swift
//  OneThing
//
//  Created by 윤동주 on 5/4/25.
//

//
//  MyPageEditJobView.swift
//  OneThing
//
//  Created by 윤동주 on 4/24/25.
//

import SwiftUI

struct MyPageEditRelationshipView: View {
    
    @Environment(\.myPageCoordinator) var myPageCoordinator
    
    @Binding var store: MyPageEditStore

    @State private var status: RelationshipStatus?
    @State private var isConsidered: Bool = false
    
    private let considerOptions = [
        (true, "같은 상태인 사람만 만나고 싶어요"),
        (false, "연애 상태는 신경쓰지 않아도 괜찮아요")
    ]
    
    var body: some View {
        
        OTBaseView(String(describing: Self.self)) {
            
            VStack {
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("연애 상태")
                            .otFont(.caption1)
                            .fontWeight(.semibold)
                            .foregroundStyle(.gray800)
                        
                        VStack(spacing: 10) {
                            ForEach(RelationshipStatus.allCases) { status in
                                OTLButton(
                                    buttonTitle: status.toKorean,
                                    action: { self.status = status },
                                    isClicked: self.status == status
                                )
                            }
                        }
                    }
                    .padding(.top, 32)
                    
                    Rectangle()
                        .fill(.gray200)
                        .frame(height: 1)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("모임 매칭시 연애 상태 고려 여부")
                            .otFont(.caption1)
                            .fontWeight(.semibold)
                            .foregroundStyle(.gray800)
                        
                        VStack(spacing: 12) {
                            ForEach(considerOptions, id: \.0) { selected, title in
                                OTLButton(
                                    buttonTitle: title,
                                    action: { self.isConsidered = selected },
                                    isClicked: self.isConsidered == selected
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal, 17)
                
                Spacer()
                
                Rectangle()
                    .fill(.gray200)
                    .frame(height: 1)
                
                OTXXLButton(
                    buttonTitle: "완료",
                    action: {
                        Task {
                            await self.store.send(.updateRelationship(self.status, self.isConsidered))
                        }
                    },
                    isClickable: self.status != nil && self.isConsidered
                )
                .padding(.horizontal, 17)
                .padding(.top, 10)
                .onChange(of: self.store.state.isRelationshipUpdated) { _, newValue in
                    if newValue { self.myPageCoordinator.pop() }
                }
            }
            .taskForOnce { await self.store.send(.relationship) }
            .onChange(of: self.store.state.relationship) { _, newValue in
                self.status = newValue?.status
                self.isConsidered = newValue?.isConsidered ?? false
            }
        }
        .navigationBar(
            title: "연애 상태 변경",
            hidesBackButton: true,
            rightButtons: [
                AnyView(
                    Button(
                        action: { self.myPageCoordinator.pop() },
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
        // .navigationBarBackButtonHidden()
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
    MyPageEditRelationshipView(store: .constant(myPageEditStoreForPreview))
}
