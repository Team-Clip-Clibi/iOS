//
//  SignUpNameView.swift
//  OneThing
//
//  Created by 윤동주 on 4/1/25.
//

import SwiftUI

struct SignUpNameView: View {
    
    @Environment(\.signUpCoordinator) var signUpCoordinator
    
    @Binding var store: SignUpStore
    
    @State var text: String = ""
    @State var nicknameRule: NicknameRule = .normal
    
    var body: some View {
        
        OTBaseView(String(describing: Self.self)) {
            
            VStack {
                
                VStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("원띵에 오신 당신, 환영해요!")
                                .otFont(.subtitle2)
                                .fontWeight(.semibold)
                                .foregroundStyle(.gray600)
                            Text("실명을 입력해주세요")
                                .otFont(.heading2)
                                .fontWeight(.bold)
                                .foregroundStyle(.gray800)
                        }
                        Spacer()
                    }
                    .padding(.top, 32)
                    
                    TextField("ex) 홍길동", text: $text)
                        .padding(.horizontal, 17)
                        .frame(height: 60)
                        .background(.gray100)
                        .cornerRadius(12)
                        .padding(.top, 32)

                    HStack {
                        Text("실명은 서비스 내에서 공개되지 않으니,\n안심하고 입력해주세요.")
                            .otFont(.caption1)
                            .fontWeight(.semibold)
                            .foregroundStyle(.gray600)
                        
                        Spacer()
                    }
                    .padding(.top, 10)
                    Spacer()
                }
                .padding(.horizontal, 17)
                
                Rectangle()
                    .fill(.gray200)
                    .frame(height: 1)
                OTXXLButton(
                    buttonTitle: "다음",
                    action: {
                        Task {
                            await self.store.send(.updateUsername(text))
                        }
                    },
                    isClickable: true
                )
                .padding(.horizontal, 17)
                .onChange(of: self.store.state.isUsernameUpdated) { _, new in
                    if new {
                        self.signUpCoordinator.push(to: .auth(.signUpNickname))
                    }
                }
            }
        }
        .navigationBar(
            title: "회원가입",
            rightButtons: [
                AnyView(
                    Text("2/4")
                        .otFont(.caption1)
                        .fontWeight(.semibold)
                        .foregroundStyle(.purple400)
                        .frame(width: 24, height: 24)
                )
            ],
            onBackButtonTap: {
                self.text = ""
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
    SignUpNameView(store: .constant(signUpStoreForPreview))
}
