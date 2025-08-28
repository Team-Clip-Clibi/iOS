//
//  SignUpPhoneNumberView.swift
//  OneThing
//
//  Created by 윤동주 on 4/1/25.
//

import SwiftUI

struct SignUpPhoneNumberView: View {
    
    @Environment(\.signUpCoordinator) var signUpCoordinator
    
    @Binding var store: SignUpStore
    
    @State var text: String = ""
    @State var nicknameRule: NicknameRule = .normal
    @State var isClickable: Bool = false
    
    var body: some View {
        
        OTBaseView(String(describing: Self.self)) {
            
            VStack {
                
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("원띵과 함께할 회원님의")
                                .otFont(.subtitle2)
                                .fontWeight(.semibold)
                                .foregroundStyle(.gray600)
                            Text("휴대폰 번호를 알려주세요")
                                .otFont(.heading2)
                                .fontWeight(.bold)
                                .foregroundStyle(.gray800)
                        }
                        Spacer()
                    }
                    .padding(.top, 32)
                    
                    TextField("휴대폰 번호", text: $text)
                        .keyboardType(.numberPad)
                        .padding(.horizontal, 17)
                        .frame(height: 60)
                        .background(.gray100)
                        .cornerRadius(12)
                        .padding(.top, 32)
                        .onChange(of: text) { oldValue, newValue in
                            
                            let digits = newValue.filter { $0.isNumber }
                            let limited = String(digits.prefix(11))
                            
                            text = limited.withHypen
                            
                            isClickable = (limited.count == 10 || limited.count == 11)
                            && limited.hasPrefix("01")
                        }
                    
                    Spacer()
                }
                .padding(.horizontal, 17)
                
                BottomButton(
                    isClickable: $isClickable,
                    title: "다음",
                    buttonTapAction: {
                        Task { await self.store.send(.updatePhoneNumber(text)) }
                    }
                )
                .onChange(of: self.store.state.isPhoneNumberUpdated) { _, new in
                    if new {
                        self.signUpCoordinator.push(to: .auth(.signUpName))
                    }
                }
            }
        }
        .navigationBar(
            title: "회원가입",
            hidesBottomSeparator: false,
            rightButtons: [
                AnyView(
                    Text("1/4")
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

extension String {
    /// 숫자만 뽑아서 XXX-XXXX-XXXX 형태로 하이픈 삽입
    public var withHypen: String {
        // 1. 숫자만 남기기
        let digits = self.filter { $0.isNumber }
        // 2. 최대 11자리까지만
        let capped = String(digits.prefix(11))
        // 3. 자리수에 따라 하이픈 삽입
        var result = capped
        if result.count > 3 {
            result.insert("-", at: result.index(result.startIndex, offsetBy: 3))
        }
        if result.count > 8 {
            // 앞에서 삽입된 하이픈까지 포함한 인덱스 8 (원래 숫자 7번째 뒤)
            result.insert("-", at: result.index(result.startIndex, offsetBy: 8))
        }
        return result
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
    SignUpPhoneNumberView(store: .constant(signUpStoreForPreview))
}
