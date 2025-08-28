//
//  Typography_modifier.swift
//  OneThing
//
//  Created by 오현식 on 8/19/25.
//

import SwiftUI

struct TypographyModifier: ViewModifier {
    let typography: Typography
    
    func body(content: Content) -> some View {
        content
            .font(self.typography.font)
            .lineSpacing((self.typography.lineHeight - self.typography.uiFont.pointSize) / 2)
            .padding(.vertical, (self.typography.lineHeight - self.typography.uiFont.pointSize) / 2)
    }
}

extension View {
    
    func otFont(_ typography: Typography) -> some View {
        self.modifier(TypographyModifier(typography: typography))
    }
}
