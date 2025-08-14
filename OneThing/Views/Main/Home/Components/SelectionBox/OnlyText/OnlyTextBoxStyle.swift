//
//  OnlyTextBoxStyle.swift
//  OneThing
//
//  Created by 오현식 on 5/20/25.
//

import SwiftUI

struct OnlyTextBoxStyle: ToggleStyle {
    
    var alignment: Alignment = .center
    var backgroundTapAction: ((Configuration) -> Void)? = nil
    
    func makeBody(configuration: Configuration) -> some View {
        
        Button {
            self.backgroundTapAction?(configuration)
        } label: {
            
            HStack {
                Spacer().frame(width: self.alignment == .center ? 0: 16)
                
                configuration.label
                    .otFont(.body1)
                    .foregroundStyle(.gray800)
                    .frame(maxWidth: .infinity, alignment: self.alignment)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(configuration.isOn ? .purple100: .gray100)
        .clipShape(.rect(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(configuration.isOn ? .purple200: .gray100, lineWidth: 1)
        )
    }
}

struct OnlyTextBoxForPreview: View {
    
    @State var isOn: Bool = false
    var isSelectable: Bool = true
    var alignment: Alignment = .center
    
    var body: some View {
        
        Toggle("text", isOn: $isOn)
            .toggleStyle(OnlyTextBoxStyle(alignment: self.alignment))
    }
}

#Preview {
    OnlyTextBoxForPreview()
        .frame(width: 175)
    OnlyTextBoxForPreview(alignment: .leading)
        .frame(width: 175)
    OnlyTextBoxForPreview(isOn: true)
        .frame(width: 175)
}
