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
            HStack(spacing: 14) {
                if pressed {
                    Spacer()
                }
                if buttonImage != nil {
                    buttonImage
                }
                Text(buttonTitle)
                    .otFont(.body1)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .foregroundStyle(.gray800)
                Spacer()

            }
            .padding(.horizontal, 16)
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
    
    OTLButton(
        buttonImage: Image(.bellOutlined),
        buttonTitle: "알림 설정",
        backgroundColor: Color.white100,
        borderColor: Color.white100,
        action: { },
        isClicked: false
    )
}

