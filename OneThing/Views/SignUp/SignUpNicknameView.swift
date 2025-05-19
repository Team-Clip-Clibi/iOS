//
//  SignUpNicknameView.swift
//  OneThing
//
//  Created by 윤동주 on 3/30/25.
//

import SwiftUI

struct SignUpNicknameView: View {
    
    
    @State var text: String = ""
    @State var nicknameRule: NicknameRule = .nothing
    
    @Binding var authPathManager: OTAuthPathManager
    @Binding var viewModel: SignUpViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            OTNavigationBar(
                leftButtonType: .back,
                title: "회원가입",
                phase: 3,
                leftAction: {
                    self.authPathManager.pop()
                },
                rightAction: {}
            )
            
            VStack(spacing: 0) {
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
                                    let result = try await viewModel.isNicknameAvailable(nickname: text)
                                    print(result)
                                    if result {
                                        nicknameRule = .available
                                    } else {
                                        nicknameRule = .duplicate
                                    }
                                }
                            }
                        },
                        isClickable: nicknameRule == .normal
                    )
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
                        let result = try await viewModel.updateNickname(nickname: text)
                        if result {
                            authPathManager.push(path: .signUpMoreInformation)
                        } else {
                            print(text)
                        }
                    }
                },
                isClickable: nicknameRule == .available)
            .padding(.horizontal, 17)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    SignUpNicknameView(authPathManager: .constant(OTAuthPathManager()), viewModel: .constant(SignUpViewModel()))
}
