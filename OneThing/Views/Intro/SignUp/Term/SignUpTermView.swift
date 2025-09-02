//
//  SignUpAssignView.swift
//  OneThing
//
//  Created by 윤동주 on 3/30/25.
//

import SwiftUI

struct SignUpTermView: View {
    
    @Environment(\.signUpCoordinator) var signUpCoordinator
    
    @Binding var store: SignUpStore
    
    var body: some View {
        
        OTBaseView(String(describing: Self.self)) {
            
            VStack(spacing: 0) {
                
                VStack(spacing: 0) {
                    HStack {
                        Text("원띵 서비스 이용에\n동의해주세요")
                            .otFont(.heading2)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.top, 32)
                    
                    Button {
                        Task {
                            self.store.state.isAllTermsAccepted ?
                            await self.store.send(.updateToDeniedTerms([0, 1, 2])) :
                            await self.store.send(.updateToAcceptTerms([0, 1 ,2]))
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Image(
                                self.store.state.isAllTermsAccepted
                                ? "checkedBox"
                                : "uncheckedBox"
                            )
                            .resizable()
                            .frame(width: 32, height: 32)
                            .scaleEffect(self.store.state.isAllTermsAccepted ? 1.1: 1.0)
                            .animation(
                                .spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.3),
                                value: self.store.state.isAllTermsAccepted
                            )
                            Text("서비스 약관 모두 동의")
                                .otFont(.subtitle2)
                                .fontWeight(.semibold)
                                .foregroundColor(
                                    self.store.state.isAllTermsAccepted
                                    ? .gray800
                                    : .gray600
                                )
                            Spacer()
                        }
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .padding(.leading, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    self.store.state.isAllTermsAccepted
                                    ? .purple100
                                    : .gray100
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    self.store.state.isAllTermsAccepted
                                    ? Color.purple200
                                    : .clear,
                                    lineWidth: 1
                                )
                        )
                    }
                    .padding(.top, 16)
                    Group {
                        ForEach(self.store.state.terms.indices, id: \.self) { index in
                            let term = self.store.state.terms[index]
                            Button {
                                Task {
                                    term.isAccepted ?
                                    await self.store.send(.updateToDeniedTerms([index])) :
                                    await self.store.send(.updateToAcceptTerms([index]))
                                }
                            } label: {
                                HStack(spacing: 10) {
                                    Image(
                                        term.isAccepted
                                        ? "checkedBox"
                                        : "uncheckedBox"
                                    )
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .scaleEffect(term.isAccepted ? 1.1 : 1.0)
                                    .animation(
                                        .spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.3),
                                        value: term.isAccepted
                                    )
                                    
                                    Text("\(term.isRequired ? "[필수]" : "[선택]") \(term.title)")
                                        .otFont(.subtitle2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(term.isAccepted ? .gray800 : .gray600)
                                    
                                    Spacer()
                                    Image(.rightArrowOutlined)
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundStyle(.gray400)
                                }
                                .frame(height: 60)
                                .frame(maxWidth: .infinity)
                                .padding(.leading, 16)
                                
                            }
                        }
                    }
                    
                    Spacer()
                    
                    OTXXLButton(
                        buttonTitle: "동의하고 가입하기",
                        action: {
                            Task {
                                await self.store.send(.signUpWithKakao)
                            }
                        },
                        isClickable: self.store.state.isRequiredTermsAccepted
                    )
                    .onChange(of: self.store.state.isSuccessSignUpByKakao) { _, new in
                        if new {
                            self.signUpCoordinator.push(to: .auth(.signUpPhoneNumber))
                        }
                    }
                }
                .padding(.horizontal, 17)
                Spacer()
            }
        }
        .navigationBar(
            title: "회원가입",
            hidesBottomSeparator: false,
            onBackButtonTap: {
                Task { await self.store.send(.updateToDeniedTerms([0, 1, 2])) }
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
    SignUpTermView(store: .constant(signUpStoreForPreview))
}
