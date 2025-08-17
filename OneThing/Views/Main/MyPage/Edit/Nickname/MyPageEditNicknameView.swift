//
//  MyPageNicknameEditView.swift
//  OneThing
//
//  Created by 윤동주 on 4/23/25.
//

import SwiftUI

struct MyPageEditNicknameView: View {
    
    @Environment(\.myPageCoordinator) var myPageCoordinator
    
    @Binding var store: MyPageEditStore
    
    @State var text: String = ""
    @State var nicknameRule: NicknameRule = .nothing
    
    var body: some View {
        
        OTBaseView(String(describing: Self.self)) {
            
            VStack {
                
                VStack {
                    TextField("닉네임", text: $text)
                        .frame(height: 48)
                        .overlay(
                                // 높이 1 포인트의 사각형을 바닥에 붙여서 언더라인 역할을 합니다.
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.gray500),  // 원하는 색으로 변경
                                alignment: .bottom
                            )
                        .onChange(of: text) { oldValue, newValue in
                            
                            // 닉네임 규칙 메시지 변경
                            if newValue.count > 0 && newValue.count < 2 {
                                nicknameRule = .tooShort
                            } else if newValue.count > 8 {
                                nicknameRule = .tooLong
                            } else if newValue.range(of: "[^a-zA-Z가-힣ㄱ-ㅎㅏ-ㅣ]", options: .regularExpression) != nil {
                                nicknameRule = .invalidCharacter
                            } else {
                                nicknameRule = .normal
                            }
                        }
                        .padding(.top, 32)
                    HStack(alignment: .center) {
                        Text(nicknameRule.message)
                            .otFont(.caption1)
                            .fontWeight(.semibold)
                            .foregroundStyle(nicknameRule.textColor)
                        
                        Spacer()
                        
                        OTSButton(
                            buttonTitle: "중복 확인",
                            action: {
                                if nicknameRule == .normal {
                                    Task {
                                        await self.store.send(.checkNicknameAvailable(text))
                                    }
                                }
                            },
                            isClickable: nicknameRule == .normal
                        )
                        .onChange(of: self.store.state.isNicknameAvailable) { _, newValue in
                            self.nicknameRule = newValue ? .available: .duplicate
                        }
                    }
                    .padding(.top, 10)
                    Spacer()
                }
                .padding(.horizontal, 17)
                
                Rectangle()
                    .fill(.gray200)
                    .frame(height: 1)
                OTXXLButton(
                    buttonTitle: "완료",
                    action: {
                        Task {
                            await self.store.send(.updateNickname(text))
                        }
                    },
                    isClickable: nicknameRule == .available
                )
                .padding(.horizontal, 17)
                .padding(.top, 10)
                .onChange(of: self.store.state.isNicknameUpdated) { _, newValue in
                    if newValue { self.myPageCoordinator.dismissCover() }
                }
            }
            .taskForOnce { await self.store.send(.profile) }
            .onChange(of: self.store.state.profileInfo) { _, newValue in
                self.text = newValue?.nickname ?? ""
            }
        }
        .navigationBar(
            title: "닉네임 변경",
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
    MyPageEditNicknameView(store: .constant(myPageEditStoreForPreview))
}
