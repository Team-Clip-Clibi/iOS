//
//  EnterContentView.swift
//  OneThing
//
//  Created by 오현식 on 5/20/25.
//

import SwiftUI

struct EnterContentView: View {
    
    enum Constants {
        /// 임의의 타이머 interval, 4초
        static let timerInterval: TimeInterval = 4
    }
    
    @Binding var content: String
    @Binding var buttonEnable: Bool
    
    @State private var currentIndex: Int = 0
    
    let titles: [String]
    let placeholder: String
    let maxCharacters: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(.purple100)
            
            let title = self.titles[self.currentIndex]
            Text(title)
                .otFont(.body1)
                .foregroundStyle(.gray800)
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .id(self.currentIndex)
                .intervalWithAnimation(
                    self.titles.count,
                    duration: Constants.timerInterval,
                    transition: .opacity.combined(with: .offset(y: 5)),
                    onIndexChanged: { new in
                        withAnimation(.easeInOut(duration: 0.4)) {
                            self.currentIndex = new
                        }
                    }
                )
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .frame(height: 32)
        .clipped()
        
        Spacer().frame(height: 4)
        
        VStack(spacing: 4) {
            TextField(
                self.placeholder,
                text: $content,
                prompt: Text(self.placeholder)
                    .foregroundColor(.gray500)
            )
                .otFont(.body2)
                .foregroundColor(.gray800)
                .tint(.purple400)
                .frame(height: 48)
                .overlay(
                    Rectangle()
                        .frame(width: nil, height: 1, alignment: .bottom)
                        .foregroundStyle(.gray500),
                    alignment: .bottom
                )
                .onChange(of: self.content) { _, newText in
                    let prefixText = String(newText.prefix(self.maxCharacters))
                    self.content = prefixText
                    self.buttonEnable = prefixText.count >= 8
                }
            
            Text("\(self.content.count)/\(self.maxCharacters)")
                .otFont(.caption2)
                .foregroundStyle(.gray700)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    EnterContentView(
        content: .constant(""),
        buttonEnable: .constant(false),
        titles: ["ex. 타이틀", "ex. 타이틀 222"],
        placeholder: "플레이스홀더",
        maxCharacters: 50
    )
}
