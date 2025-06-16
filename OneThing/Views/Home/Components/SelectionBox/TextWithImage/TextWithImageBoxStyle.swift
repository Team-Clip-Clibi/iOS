//
//  TextWithImageBoxStyle.swift
//  OneThing
//
//  Created by 오현식 on 5/20/25.
//

import SwiftUI

struct TextWithImageBoxStyle: ToggleStyle {
    
    enum ViewType {
        case matching
        case meeting
    }
    
    let viewType: ViewType
    let imageResource: ImageResource
    
    var backgroundTapAction: ((Configuration) -> Void)? = nil
    
    func makeBody(configuration: Configuration) -> some View {
        
        Button {
            self.backgroundTapAction?(configuration)
        } label: {
            
            switch self.viewType {
            case .matching:
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
            case .meeting:
                VStack(spacing: 6) {
                    Image(self.imageResource)
                        .resizable()
                        .frame(width: 60, height: 60)
                    
                    configuration.label
                        .otFont(configuration.isOn ? .body1: .body2)
                        .foregroundStyle(configuration.isOn ? .purple400: .gray600)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 86)
            }
        }
    }
}

struct TextWithImageBoxForPreview: View {
    
    @State var isOn: Bool = false
    var isSelectable: Bool = true
    let viewType: TextWithImageBoxStyle.ViewType
    
    var body: some View {
        
        Toggle("자기계발", isOn: $isOn)
            .toggleStyle(TextWithImageBoxStyle(viewType: self.viewType, imageResource: .stepup))
    }
}

#Preview {
    TextWithImageBoxForPreview(viewType: .matching)
        .frame(width: 175)
    TextWithImageBoxForPreview(isOn: true, viewType: .matching)
        .frame(width: 175)
    
    TextWithImageBoxForPreview(viewType: .meeting)
        .frame(width: 175)
    TextWithImageBoxForPreview(isOn: true, viewType: .meeting)
        .frame(width: 175)
}
