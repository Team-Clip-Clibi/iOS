//
//  SignUpNicknameView.swift
//  OneThing
//
//  Created by 윤동주 on 3/30/25.
//

import SwiftUI

struct SignUpNicknameView: View {
    
    @Environment(\.signUpCoordinator) var signUpCoordinator
    
    @Binding var store: SignUpStore
    
    @State var text: String = ""
    @State var nicknameRule: NicknameRule = .nothing
    
    var body: some View {
        
        OTBaseView(String(describing: Self.self)) {
            
            VStack {
                
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("원띵에서 뭐라고 부를까요?")
                                .otFont(.subtitle2)
                                .fontWeight(.semibold)
                                .foregroundStyle(.gray600)
                            Text("닉네임을 입력해주세요")
                                .otFont(.heading2)
                                .fontWeight(.bold)
                                .foregroundStyle(.gray800)
                        }
                        Spacer()
                    }
                    .padding(.top, 32)
                    
                    TextField("닉네임", text: $text)
                        .padding(.horizontal, 17)
                        .frame(height: 60)
                        .background(.gray100)
                        .cornerRadius(12)
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
                    
                    HStack(alignment: .top) {
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
                        .onChange(of: self.store.state.isNicknameValid) { _, new in
                            if new {
                                self.nicknameRule = .available
                            } else {
                                self.nicknameRule = .duplicate
                            }
                        }
                    }
                    .padding(.top, 10)
                    Spacer()
                }
                .padding(.horizontal, 17)
                
                BottomButton(
                    isClickable: Binding(
                        get: { self.nicknameRule == .available },
                        set: { _ in }
                    ),
                    title: "다음",
                    buttonTapAction: {
                        Task { await self.store.send(.updateNickname(text)) }
                    }
                )
                .onChange(of: self.store.state.isNicknameUpdated) { _, new in
                    if new {
                        self.signUpCoordinator.push(to: .auth(.signUpMoreInformation))
                    }
                }
            }
        }
        .navigationBar(
            title: "회원가입",
            hidesBottomSeparator: false,
            rightButtons: [
                AnyView(
                    Text("3/4")
                        .otFont(.caption1)
                        .fontWeight(.semibold)
                        .foregroundStyle(.purple400)
                        .frame(width: 24, height: 24)
                )
            ],
            onBackButtonTap: {
                self.signUpCoordinator.pop()
            }
        )
    }
}

#Preview {
    let signUpStoreForPreview = SignUpStore(
        socialLoginUseCase: SocialLoginUseCase(),
        updateUserNameUseCase: UpdateUserNameUseCase(),
        updateNicknameUseCase: UpdateNicknameUseCase(),
        updatePhoneNumberUseCase: UpdatePhoneNumberUseCase(),
        getNicknameAvailableUseCase: GetNicknameAvailableUseCase(),
        getBannerUseCase: GetBannerUseCase()
    )
    SignUpNicknameView(store: .constant(signUpStoreForPreview))
}
