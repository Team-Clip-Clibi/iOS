//
//  EnterContentView.swift
//  OneThing
//
//  Created by 오현식 on 5/20/25.
//

import SwiftUI

struct EnterContentView: View {
    
    @Binding var content: String
    @Binding var buttonEnable: Bool
    
    let title: String
    let placeholder: String
    let maxCharacters: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(.purple100)
            
            Text(self.title)
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
                .otFont(.captionTwo)
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
        title: "ex. 타이틀",
        placeholder: "플레이스홀더",
        maxCharacters: 50
    )
}
