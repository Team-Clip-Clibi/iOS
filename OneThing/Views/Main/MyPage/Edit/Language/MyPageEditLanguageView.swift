//
//  MyPageEditLanguageView.swift
//  OneThing
//
//  Created by 윤동주 on 5/6/25.
//

import SwiftUI

struct MyPageEditLanguageView: View {
    
    @Environment(\.myPageCoordinator) var myPageCoordinator
    
    @Binding var store: MyPageEditStore
    
    @State private var language: Language?
    
    var body: some View {
        
        OTBaseView(String(describing: Self.self)) {
            
            VStack {
                VStack(spacing: 12) {
                    ForEach(Language.allCases, id: \.self) { option in
                        OTLButton(
                            buttonTitle: option.toKorean,
                            action: { self.language = option },
                            isClicked: self.language == option
                        )
                    }
                }
                .padding(.top, 32)
                .padding(.horizontal, 17)
                
                Spacer()
                
                Rectangle()
                    .fill(.gray200)
                    .frame(height: 1)
                
                OTXXLButton(
                    buttonTitle: "완료",
                    action: {
                        Task {
                            await self.store.send(.updateLanguage(self.language))
                        }
                    },
                    isClickable: self.language != nil
                )
                .padding(.horizontal, 17)
                .padding(.top, 10)
                .onChange(of: self.store.state.isLanguageUpdated) { _, newValue in
                    if newValue { self.myPageCoordinator.dismissCover() }
                }
            }
            .taskForOnce { await self.store.send(.language) }
            .onChange(of: self.store.state.language) { _, newValue in
                self.language = newValue
            }
        }
        .navigationBar(
            title: "사용 언어 변경",
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
    MyPageEditLanguageView(store: .constant(myPageEditStoreForPreview))
}
