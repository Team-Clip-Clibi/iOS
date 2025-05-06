//
//  OTXLButton.swift
//  OneThing
//
//  Created by 윤동주 on 4/6/25.
//

import SwiftUI

struct OTXLButton: View {
    
    var buttonTitle: String
    var isDropDownButton: Bool = false
    var action: () -> Void
    var isClicked: Bool
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(buttonTitle)
                    .otFont(.body1)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .foregroundStyle(.gray800)
                    .padding(.vertical, 20)
                    .padding(.leading, 17)
                
                Spacer()

                if isDropDownButton {
                    Image(.caretDownOutlined)
                        .padding(.trailing, 17)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(isClicked ? .purple100 : .gray100)
                    .animation(.easeInOut(duration: 0.3), value: isClicked)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isClicked ? .purple200 : .gray100, lineWidth: 1)
            )
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        
    }
}

#Preview {
    OTXLButton(buttonTitle: "Button/XL", action: {}, isClicked: true)
}

