//
//  TextWithImageBoxStyle.swift
//  OneThing
//
//  Created by 오현식 on 5/20/25.
//

import SwiftUI

struct TextWithImageBoxStyle: ToggleStyle {
    
    let imageResource: ImageResource
    var backgroundTapAction: ((Configuration) -> Void)? = nil
    
    func makeBody(configuration: Configuration) -> some View {
        
        Button {
            self.backgroundTapAction?(configuration)
        } label: {
            
            VStack(spacing: 2) {
                Image(self.imageResource)
                    .resizable()
                    .frame(width: 40, height: 40)
                
                configuration.label
                    .otFont(.body2)
                    .foregroundStyle(.gray800)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 88)
            .background(configuration.isOn ? .purple100: .gray100)
            .clipShape(.rect(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(configuration.isOn ? .purple200: .gray100, lineWidth: 1)
            )
        }
    }
}

struct TextWithImageBoxForPreview: View {
    
    @State var isOn: Bool = false
    var isSelectable: Bool = true
    
    var body: some View {
        
        Toggle("자기계발", isOn: $isOn)
            .toggleStyle(TextWithImageBoxStyle(imageResource: .stepup))
    }
}

#Preview {
    TextWithImageBoxForPreview()
        .frame(width: 175)
    TextWithImageBoxForPreview(isOn: true)
        .frame(width: 175)
}
