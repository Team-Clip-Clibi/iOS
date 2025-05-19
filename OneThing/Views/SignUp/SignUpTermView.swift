//
//  SignUpAssignView.swift
//  OneThing
//
//  Created by 윤동주 on 3/30/25.
//

import SwiftUI

struct SignUpTermView: View {
    
    @Binding var viewModel: SignUpViewModel
    @Binding var authPathManager: OTAuthPathManager
    
    var body: some View {
        
        VStack(spacing: 0) {
            OTNavigationBar(
                leftButtonType: .back,
                title: "회원가입",
                phase: 0,
                leftAction: {
                    self.authPathManager.pop()
                },
                rightAction: {}
            )
            
            VStack(spacing: 0) {
                HStack {
                    Text("원띵 서비스 이용에\n동의해주세요")
                        .otFont(.heading2)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.top, 32)
                
                Button {
                    viewModel.isAllTermsAccepted
                    ? viewModel.setAllTermsDenied()
                    : viewModel.setAllTermsAccepted()
                } label: {
                    HStack(spacing: 10) {
                        Image(
                            viewModel.isAllTermsAccepted
                            ? "checkedBox"
                            : "uncheckedBox"
                        )
                        .resizable()
                        .frame(width: 32, height: 32)
                        .scaleEffect(viewModel.isAllTermsAccepted ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.3), value: viewModel.isAllTermsAccepted)
                        Text("서비스 약관 모두 동의")
                            .otFont(.subtitle2)
                            .fontWeight(.semibold)
                            .foregroundColor(
                                viewModel.isAllTermsAccepted
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
                                viewModel.isAllTermsAccepted
                                ? .purple100
                                : .gray100
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                viewModel.isAllTermsAccepted
                                ? Color.purple200
                                : .clear,
                                lineWidth: 1
                            )
                    )
                }
                .padding(.top, 16)
                Group {
                    ForEach($viewModel.terms) { $term in
                        Button {
                            term.isAccepted.toggle()
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
                                .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.3), value: term.isAccepted)
                                
                                Text("\(term.isRequired ? "[필수]" : "[선택]") \(term.title)")
                                    .otFont(.subtitle2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(term.isAccepted ? .gray800 : .gray600)
                                
                                Spacer()
                                Image("rightArrow")
                            }
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .padding(.leading, 16)
                            
                        }
                    }
                }
                
                Spacer()
                
                OTXXLButton(
                    buttonTitle: "원띵 시작하기",
                    action: {
                        Task {
                            do {
                                try await viewModel.signUpWithKakao()
                                
                                authPathManager.push(path: .signUpPhoneNumber)
                            } catch {
                                print(error)
                            }
                            
                        }
                    },
                    isClickable: viewModel.isRequiredTermsAccepted)
            }
            .padding(.horizontal, 17)
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}



#Preview {
    SignUpTermView(
        viewModel: .constant(SignUpViewModel()),
        authPathManager: .constant(OTAuthPathManager())
    )
}
