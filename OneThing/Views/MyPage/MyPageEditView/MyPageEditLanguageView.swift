//
//  MyPageEditLanguageView.swift
//  OneThing
//
//  Created by 윤동주 on 5/6/25.
//

import SwiftUI

struct MyPageEditLanguageView: View {
    
    @State private var language: Language?
    
    @Binding var pathManager: OTAppPathManager
    @Binding var viewModel: MyPageEditViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            OTNavigationBar(
                rightButtonType: .close,
                title: "사용 언어 변경",
                phase: 0,
                rightAction: {
                    _ = self.pathManager.myPagePaths.popLast()
                }
            )
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
                        viewModel.language = self.language
                        
                        let result = try await viewModel.updateLanguage()
                        
                        if result {
                            pathManager.pop()
                        }
                    }
                },
                isClickable: true)
            .padding(.horizontal, 17)
            .padding(.top, 10)
        }
        .task {
            Task {
                self.language = viewModel.language
                
                pathManager.isTabBarHidden = true
            }
        }
        .onDisappear {
            pathManager.isTabBarHidden = false
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    MyPageEditLanguageView(pathManager: .constant(OTAppPathManager()), viewModel: .constant(MyPageEditViewModel()))
}
