//
//  SelectDateView.swift
//  OneThing
//
//  Created by 오현식 on 5/27/25.
//

import SwiftUI

struct SelectDateView: View {
    
    let matchingDate: String
    let matchingTime: String
    
    var onCloseButtonTapped: (() -> Void)?
    
    var body: some View {
        
        HStack {
            Text("\(self.matchingDate) · \(self.matchingTime)")
                .otFont(.body2)
                .foregroundStyle(.gray800)
            
            Spacer()
            
            Image(.closeOutlined)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(.gray300)
                .onTapGesture { self.onCloseButtonTapped?() }
        }
        .padding(.horizontal, 16)
        .frame(height: 48)
        .overlay(
            Rectangle()
                .frame(width: nil, height: 1, alignment: .bottom)
                .foregroundStyle(.gray200),
            alignment: .bottom
        )
    }
}

#Preview {
    SelectDateView(
        matchingDate: "04.18(금)",
        matchingTime: "오후 7시",
        onCloseButtonTapped: { print("@") }
    )
    SelectDateView(
        matchingDate: "04.19(토)",
        matchingTime: "오후 7시",
        onCloseButtonTapped: { print("@@") }
    )
}
