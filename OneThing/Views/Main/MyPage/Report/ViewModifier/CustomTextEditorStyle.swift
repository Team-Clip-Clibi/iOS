//
//  CustomTextEditorViewModifier.swift
//  OneThing
//
//  Created by 윤동주 on 5/11/25.
//

import SwiftUI

struct CustomTextEditorStyle: ViewModifier {
    
    let placeholder: String
    @Binding var text: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .otFont(.subtitle2)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray600)
                    .padding(16)
            }
            
            content
                .otFont(.subtitle2)
                .fontWeight(.semibold)
                .foregroundColor(.gray800)
                .padding([.leading, .trailing], 12)
                .padding(.top, 8)
                .textInputAutocapitalization(.none)
                .autocorrectionDisabled()
                .scrollContentBackground(.hidden)
            
        }
        .background(.gray100)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

extension TextEditor {
    func customStyleEditor(placeholder: String, userInput: Binding<String>) -> some View {
        self.modifier(CustomTextEditorStyle(placeholder: placeholder, text: userInput))
    }
}
