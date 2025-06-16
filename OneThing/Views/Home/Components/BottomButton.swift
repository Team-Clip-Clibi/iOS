//
//  BottomButton.swift
//  OneThing
//
//  Created by 오현식 on 5/21/25.
//

import SwiftUI

struct BottomButton: View {
    
    @Binding var isClickable: Bool
    
    let title: String
    var buttonTapAction: (() -> Void)?
    
    var body: some View {
        
        VStack(spacing: 8) {
            Rectangle()
                .frame(width: nil, height: 1)
                .foregroundStyle(.gray200)
            
            OTXXLButton(
                buttonTitle: self.title,
                action: { self.buttonTapAction?() },
                isClickable: self.isClickable
            )
            .padding(.bottom, 12)
            .padding(.horizontal, 16)
        }
    }
}
