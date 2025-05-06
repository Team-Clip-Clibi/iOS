//
//  OTSButton.swift
//  OneThing
//
//  Created by 윤동주 on 3/30/25.
//

import SwiftUI

struct OTSButton: View {
    var buttonTitle: String
    var action: () -> Void
    var isClickable: Bool
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(String(buttonTitle))
                .otFont(.body1)
                .fontWeight(.medium)
                .lineLimit(1)
                .foregroundStyle(isClickable ? .purple400 : .gray600)
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
                .frame(minWidth: 96)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(isClickable ? .purple100 : .gray200)
                        .animation(.easeInOut(duration: 0.3), value: isClickable)
                )
        }
    }
}

#Preview {
    OTSButton(buttonTitle: "Button/S", action: {}, isClickable: false)
}
