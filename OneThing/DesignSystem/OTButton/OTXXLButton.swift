//
//  OTXXLButton.swift
//  OneThing
//
//  Created by 윤동주 on 3/30/25.
//

import SwiftUI

struct OTXXLButton: View {
    
    var buttonTitle: String
    var action: () -> Void
    var isClickable: Bool
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(String(buttonTitle))
                .otFont(.title1)
                .fontWeight(.semibold)
                .lineLimit(1)
                .foregroundStyle(isClickable ? .white100 : .gray800)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(isClickable ? .purple400 : .gray200)
                        .animation(.easeInOut(duration: 0.3), value: isClickable)
                        .frame(height: 60)
                )
        }
        .frame(height: 60)
        .disabled(!isClickable)
    }
}

#Preview {
    OTXXLButton(buttonTitle: "Button/XXL", action: {}, isClickable: true)
}
