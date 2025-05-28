//
//  SelectionBoxStyle.swift
//  OneThing
//
//  Created by 오현식 on 5/14/25.
//

import SwiftUI

struct CheckBoxStyle: ToggleStyle {
    
    var backgroundTapAction: ((Configuration) -> Void)? = nil
    
    func makeBody(configuration: Configuration) -> some View {
        
        Button {
            self.backgroundTapAction?(configuration)
        } label: {
            
            HStack(spacing: 14) {
                Image(configuration.isOn ? .checkedBox: .uncheckedBox)
                    .resizable()
                    .frame(width: 24, height: 24)
                
                configuration.label
                    .otFont(.body1)
                    .foregroundStyle(.gray800)
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 48)
            .background(configuration.isOn ? .purple100: .gray100)
            .clipShape(.rect(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(configuration.isOn ? .purple200: .gray100, lineWidth: 1)
            )
        }
    }
}

struct CheckBoxForPreview: View {
    
    @State var isOn: Bool = false
    var isSelectable: Bool = true
    
    var body: some View {
        
        Toggle("text", isOn: $isOn)
            .padding(.horizontal, 16)
            .toggleStyle(CheckBoxStyle())
    }
}

#Preview {
    CheckBoxForPreview()
    CheckBoxForPreview(isOn: true)
}
