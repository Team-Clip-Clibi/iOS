//
//  MyPageEditDietaryView.swift
//  OneThing
//
//  Created by 윤동주 on 5/6/25.
//

import SwiftUI

struct MyPageEditDietaryView: View {
    
    @Environment(\.myPageCoordinator) var myPageCoordinator
    
    @Binding var store: MyPageEditStore
    
    @State private var dietary: String = ""
    @State private var otherText: String = ""
    
    private let dietaryOptions = [
        "비건이에요",
        "베지테리언이에요",
        "글루텐프리를 지켜요",
        "다 잘먹어요",
        "기타"
    ]
    
    var body: some View {
        
        OTBaseView(String(describing: Self.self)) {
            
            VStack {
                
                VStack(spacing: 12) {
                    ForEach(dietaryOptions, id: \.self) { option in
                        OTLButton(
                            buttonTitle: option,
                            action: { self.dietary = option },
                            isClicked: self.dietary == option
                        )
                    }
                }
                .padding(.top, 32)
                .padding(.horizontal, 17)
                
                VStack {
                    if self.dietary == "기타" {
                        
                        Rectangle()
                            .fill(.gray200)
                            .frame(height: 1)
                        
                        TextField(
                            "",
                            text: $otherText,
                            prompt: Text("알레르기나 특별한 식사 성향을 입력해주세요")
                                .foregroundColor(.gray500)
                        )
                        .otFont(.body1)
                        .fontWeight(.medium)
                        .frame(height: 48)
                        .cornerRadius(12)
                        .overlay(
                            Rectangle()
                                .fill(Color.gray500)
                                .frame(height: 1),
                            alignment: .bottom
                        )
                        .padding(.top, 24)
                        
                        HStack {
                            Spacer()
                            Text("\(self.otherText.count)/100")
                                .otFont(.captionTwo)
                                .fontWeight(.medium)
                                .foregroundStyle(.gray700)
                        }
                        .padding(.top, 4)
                    }
                }
                .padding(.top, 24)
                .padding(.horizontal, 17)
                
                Spacer()
                
                Rectangle()
                    .fill(.gray200)
                    .frame(height: 1)
                
                OTXXLButton(
                    buttonTitle: "완료",
                    action: {
                        Task {
                            await self.store.send(.updateDietary(self.dietary, self.otherText))
                        }
                    },
                    isClickable: !self.dietary.isEmpty
                )
                .padding(.horizontal, 17)
                .padding(.top, 10)
                .onChange(of: self.store.state.isDietaryUpdated) { _, newValue in
                    if newValue { self.myPageCoordinator.dismissCover() }
                }
            }
            .ignoresSafeArea(.keyboard)
            .taskForOnce { await self.store.send(.dietary) }
            .onChange(of: self.store.state.dietary) { _, newValue in
                self.dietary = newValue
            }
            .onChange(of: self.store.state.otherText) { _, newValue in
                self.otherText = newValue
            }
        }
        .navigationBar(
            title: "식단 제한 변경",
            hidesBackButton: true,
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
    MyPageEditDietaryView(store: .constant(myPageEditStoreForPreview))
}
