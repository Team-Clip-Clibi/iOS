//
//  MyPageEditDietaryView.swift
//  OneThing
//
//  Created by 윤동주 on 5/6/25.
//

import SwiftUI

struct MyPageEditDietaryView: View {
    
    @Binding var pathManager: OTAppPathManager
    @Binding var viewModel: MyPageEditViewModel
    
    
    private let dietaryOptions = [
        "비건이에요",
        "베지테리언이에요",
        "글루텐프리를 지켜요",
        "다 잘먹어요",
        "기타"
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            OTNavigationBar(
                rightButtonType: .close,
                title: "식단 제한 변경",
                phase: 0,
                rightAction: {
                    _ = self.pathManager.myPagePaths.popLast()
                }
            )
            VStack(spacing: 12) {
                ForEach(dietaryOptions, id: \.self) { option in
                    OTLButton(
                        buttonTitle: option,
                        action: { viewModel.dietary = option },
                        isClicked: viewModel.dietary == option
                    )
                }
            }
            .padding(.top, 32)
            .padding(.horizontal, 17)
            
            VStack(spacing: 0) {
                if viewModel.dietary == "기타" {
                    
                    Rectangle()
                        .fill(.gray200)
                        .frame(height: 1)
                    
                    TextField(
                        "",
                        text: $viewModel.otherText,
                        prompt: Text("알레르기나 특별한 식사 성향을 입력해주세요")
                            .foregroundColor(.gray500)
                    )
                    .otFont(.body1)
                    .fontWeight(.medium)
                    .frame(height: 48)
                    .cornerRadius(12)
                    .onChange(of: viewModel.otherText) { _, newValue in
                        viewModel.otherText = newValue
                    }
                    .overlay(
                        Rectangle()
                            .fill(Color.gray500)
                            .frame(height: 1),
                        alignment: .bottom
                    )
                    .padding(.top, 24)
                    
                    HStack {
                        Spacer()
                        Text("\(viewModel.otherText.count)/100")
                            .otFont(.captionTwo)
                            .fontWeight(.medium)
                            .foregroundStyle(.gray700)
                    }
                    .padding(.top, 4)
                }
            }
            .padding(.top, 24)
            .padding(.horizontal, 17)
            
            Spacer()
            
            Rectangle()
                .fill(.gray200)
                .frame(height: 1)
            
            OTXXLButton(
                buttonTitle: "완료",
                action: {
                    Task {
                        let result = try await viewModel.updateDietary()
                        if result {
                            pathManager.pop()
                        }
                    }
                },
                isClickable: !viewModel.dietary.isEmpty)
            .padding(.horizontal, 17)
            .padding(.top, 10)
        }
        .ignoresSafeArea(.keyboard)
        .task {
            Task {
                try await viewModel.fetchDietary()
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
    MyPageEditDietaryView(pathManager: .constant(OTAppPathManager()), viewModel: .constant(MyPageEditViewModel()))
}
