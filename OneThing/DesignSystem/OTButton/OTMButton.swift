//
//  OTMButton.swift
//  OneThing
//
//  Created by 윤동주 on 4/13/25.
//

import SwiftUI


struct OTMButton: View {
    var buttonTitle: String
    var action: () -> Void
    var isClickable: Bool
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(String(buttonTitle))
                .otFont(.subtitle2)
                .fontWeight(.semibold)
                .lineLimit(1)
                .foregroundStyle(isClickable ? .white100 : .gray800)
                .padding(.vertical, 12)
                .frame(minWidth: 276)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(isClickable ? .purple400 : .gray200)
                        .animation(.easeInOut(duration: 0.3), value: isClickable)
                )
        }
    }
}

#Preview {
    OTMButton(buttonTitle: "Button/M", action: {}, isClickable: true)
}
