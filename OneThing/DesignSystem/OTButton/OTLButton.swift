//
//  OTLButton.swift
//  OneThing
//
//  Created by 윤동주 on 4/13/25.
//

import SwiftUI

struct OTLButton: View {
    var buttonImage: Image? = nil
    var buttonTitle: String
    var backgroundColor: Color? = nil
    var borderColor: Color? = nil
    var action: () -> Void
    var isClicked: Bool
    var pressed: Bool = false
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                if pressed {
                    Spacer()
                }
                if buttonImage != nil {
                    buttonImage
                        .padding(.leading, 17)
                }
                Text(buttonTitle)
                    .otFont(.body1)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .foregroundStyle(.gray800)
                    .padding(.leading, pressed ? 0 : 17)
                Spacer()

            }
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(backgroundColor != nil ? backgroundColor! : isClicked ? .purple100 : pressed ? .gray200 : .gray100)
                    .animation(.easeInOut(duration: 0.3), value: isClicked)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor != nil ? borderColor! : isClicked ? .purple200 : .gray100, lineWidth: 1)
            )
        }
        .frame(maxWidth: .infinity)
        
    }
}

#Preview {
    OTLButton(buttonTitle: "Button/L", action: {}, isClicked: true)
}

