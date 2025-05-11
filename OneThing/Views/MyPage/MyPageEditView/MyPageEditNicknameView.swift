//
//  MyPageNicknameEditView.swift
//  OneThing
//
//  Created by 윤동주 on 4/23/25.
//

import SwiftUI

struct MyPageEditNicknameView: View {
    
    
    @State var text: String = ""
    @State var nicknameRule: NicknameRule = .nothing
    
    @Binding var pathManager: OTAppPathManager
    @Binding var viewModel: MyPageEditViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            OTNavigationBar(
                rightButtonType: .close,
                title: "닉네임 변경",
                phase: 0,
                rightAction: {
                    _ = self.pathManager.myPagePaths.popLast()
                }
            )
            
            VStack(spacing: 0) {
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
                        } else if newValue.range(of: "[^a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ]", options: .regularExpression) != nil {
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
                buttonTitle: "완료",
                action: {
                    Task {
                        let result = try await viewModel.updateNickname(nickname: text)
                        if result {
                            pathManager.pop()
                        }
                    }
                },
                isClickable: nicknameRule == .available)
            .padding(.horizontal, 17)
            .padding(.top, 10)
            
        }
        .onAppear {
            pathManager.isTabBarHidden = true
            text = viewModel.profileInfo?.nickname ?? ""
        }
        .onDisappear {
            pathManager.isTabBarHidden = false
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    MyPageEditNicknameView(pathManager: .constant(OTAppPathManager()), viewModel: .constant(MyPageEditViewModel()))
}
