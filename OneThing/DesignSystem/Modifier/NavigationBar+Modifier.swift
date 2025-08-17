//
//  NavigationBar+Modifier.swift
//  OneThing
//
//  Created by 오현식 on 7/26/25.
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {
    
    let title: String?
    let titleAlignment: NavigationBar.TitleAlignment
    let titleView: AnyView?
    let hidesBackButton: Bool
    let hidesBottomSeparator: Bool
    let inset: EdgeInsets
    let spacing: CGFloat
    let leftButtons: [AnyView]?
    let rightButtons: [AnyView]?
    let backgroundColor: Color
    let onBackButtonTap: (() -> Void)?
    
    func body(content: Content) -> some View {
        
        VStack(spacing: 0) {
            NavigationBar(
                title: self.title,
                titleAlignment: self.titleAlignment,
                titleView: self.titleView,
                hidesBackButton: self.hidesBackButton,
                hidesBottomSeparator: self.hidesBottomSeparator,
                inset: self.inset,
                spacing: self.spacing,
                leftButtons: self.leftButtons,
                rightButtons: self.rightButtons,
                backgroundColor: self.backgroundColor,
                onBackButtonTap: self.onBackButtonTap
            )
            
            content
        }
    }
}

extension View {
    
    func navigationBar(
        title: String? = nil,
        titleAlignment: NavigationBar.TitleAlignment = .center,
        titleView: AnyView? = nil,
        hidesBackButton: Bool = false,
        hidesBottomSeparator: Bool = true,
        inset: EdgeInsets = EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16),
        spacing: CGFloat = 0,
        leftButtons: [AnyView]? = nil,
        rightButtons: [AnyView]? = nil,
        backgroundColor: Color = .white100,
        onBackButtonTap: (() -> Void)? = nil
    ) -> some View {
        self.modifier(
            NavigationBarModifier(
                title: title,
                titleAlignment: titleAlignment,
                titleView: titleView,
                hidesBackButton: hidesBackButton,
                hidesBottomSeparator: hidesBottomSeparator,
                inset: inset,
                spacing: spacing,
                leftButtons: leftButtons,
                rightButtons: rightButtons,
                backgroundColor: backgroundColor,
                onBackButtonTap: onBackButtonTap
            )
        )
    }
}
