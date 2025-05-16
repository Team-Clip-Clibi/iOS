//
//  RandomMatchingTMIView.swift
//  OneThing
//
//  Created by 오현식 on 5/15/25.
//

import SwiftUI

struct RandomMatchingTMIView: View {
    
    enum Constants {
        enum Text {
            static let naviTitle = "랜덤 모임 신청"
            
            static let title = "마지막으로 모임에서 나눌\nTMI를 입력해주세요"
            static let subTitle = "ex. 저는 시드니에 사는 것이 꿈이에요"
            
            static let placeholderText = "최소 8자, 최대 50자까지 입력할 수 있어요"
            
            static let completeButtonTitle = "완료"
        }
        
        static let progress = 1.0
        static let maxCharacters = 50
    }
    
    @Binding var appPathManager: OTAppPathManager
    @Binding var viewModel: RandomMatchingViewModel
    
    @State private var isCompleteButtonEnabled: Bool = false
    
    var body: some View {
        
        VStack {
            
            NavigationBar()
                .title(Constants.Text.naviTitle)
                .hidesBottomSeparator(true)
                .onBackButtonTap {
                    self.viewModel.currentState.tmiContent = ""
                    self.appPathManager.pop()
                }
            
            LinerProgressView(value: Constants.progress, shape: Rectangle())
                .tint(.purple400)
            
            Spacer().frame(height: 32)
            
            Text(Constants.Text.title)
                .otFont(.heading2)
                .multilineTextAlignment(.leading)
                .foregroundStyle(.gray800)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer().frame(height: 24)
            
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(.purple100)
                
                Text(Constants.Text.subTitle)
                    .otFont(.body1)
                    .foregroundStyle(.gray800)
                    .padding(.horizontal, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .frame(height: 32)
            
            Spacer().frame(height: 4)
            
            VStack(spacing: 4) {
                TextField(Constants.Text.placeholderText, text: $viewModel.currentState.tmiContent)
                    .frame(height: 48)
                    .overlay(
                        Rectangle()
                            .frame(width: nil, height: 1, alignment: .bottom)
                            .foregroundStyle(.gray500),
                        alignment: .bottom
                    )
                    .onChange(of: self.viewModel.currentState.tmiContent) { _, newText in
                        let prefixText = String(newText.prefix(Constants.maxCharacters))
                        self.viewModel.currentState.tmiContent = prefixText
                        self.isCompleteButtonEnabled = prefixText.count >= 8
                    }
                
                Text("\(self.viewModel.currentState.tmiLength)/\(Constants.maxCharacters)")
                    .otFont(.captionTwo)
                    .foregroundStyle(.gray700)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
            Rectangle()
                .frame(width: nil, height: 1)
                .foregroundStyle(.gray200)
            
            Spacer().frame(height: 8)
            
            OTXXLButton(
                buttonTitle: Constants.Text.completeButtonTitle,
                action: {
                    self.appPathManager.push(path: .random(.payment))
                },
                isClickable: self.isCompleteButtonEnabled
            )
            .padding(.horizontal, 16)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    RandomMatchingTMIView(
        appPathManager: .constant(OTAppPathManager()),
        viewModel: .constant(RandomMatchingViewModel())
    )
}
