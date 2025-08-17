//
//  SelectionBoxStyle.swift
//  OneThing
//
//  Created by 오현식 on 5/14/25.
//

import SwiftUI

struct CheckBoxStyle: ToggleStyle {
    
    enum ViewType {
        case matching
        case meeting
    }
    
    let viewType: ViewType
    
    var backgroundTapAction: ((Configuration) -> Void)? = nil
    
    func makeBody(configuration: Configuration) -> some View {
        
        Button {
            self.backgroundTapAction?(configuration)
        } label: {
            
            switch self.viewType {
            case .matching:
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
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(configuration.isOn ? .purple200: .gray100, lineWidth: 1)
                )
                .clipShape(.rect(cornerRadius: 8))
            case .meeting:
                HStack(spacing: 12) {
                    Image(configuration.isOn ? .checkSquare: .uncheckSquare)
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    configuration.label
                        .otFont(.body2)
                        .foregroundStyle(.gray700)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct CheckBoxForPreview: View {
    
    @State var isOn: Bool = false
    var isSelectable: Bool = true
    let viewType: CheckBoxStyle.ViewType
    
    var body: some View {
        
        Toggle("text", isOn: $isOn)
            .padding(.horizontal, 16)
            .toggleStyle(CheckBoxStyle(viewType: self.viewType))
    }
}

#Preview {
    CheckBoxForPreview(viewType: .matching)
    CheckBoxForPreview(isOn: true, viewType: .matching)
    
    CheckBoxForPreview(viewType: .meeting)
    CheckBoxForPreview(isOn: true, viewType: .meeting)
}
