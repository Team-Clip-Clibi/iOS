//
//  HomeGridEmptyAndFooter.swift
//  OneThing
//
//  Created by 오현식 on 5/9/25.
//

import SwiftUI

struct HomeGridEmptyAndFooter: View {
    
    enum ConstText {
        static let placeholder = "아직 확정된 모임이 없어요\n모임을 신청해 보세요!"
        static let footer = "다른 모임도\n신청해볼까요?"
    }
    
    enum Category {
        case placeholder
        case footer
    }
    
    private(set) var category: Category
    
    private var text: String {
        return self.category == .placeholder ? ConstText.placeholder : ConstText.footer
    }
    private var maxWidth: CGFloat? {
        return self.category == .placeholder ? .infinity: nil
    }
    private var width: CGFloat? {
        return self.category == .placeholder ? nil: 192
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Image(.more)
                .resizable()
                .frame(width: 40, height: 40)
            
            Text(self.text)
                .otFont(.body1)
                .multilineTextAlignment(.center)
                .foregroundStyle(.gray600)
        }
        .frame(maxWidth: self.maxWidth)
        .frame(width: self.width, height: 174)
        .background(.gray200)
        .clipShape(.rect(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(.gray300, lineWidth: 1)
        )
    }
}

#Preview {
    HomeGridEmptyAndFooter(category: .placeholder)
    HomeGridEmptyAndFooter(category: .footer)
}
