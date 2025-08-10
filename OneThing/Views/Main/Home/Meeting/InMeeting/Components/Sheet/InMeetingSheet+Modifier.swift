//
//  InMeetingSheet+Modifier.swift
//  OneThing
//
//  Created by 오현식 on 6/5/25.
//

import SwiftUI

struct InMeetingSheetModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    
    let heightRatio: CGFloat
    let cornerRadius: CGFloat
    let backgroundColor: Color
    let dismissWhenBackgroundTapped: Bool
    
    init(
        isPresented: Binding<Bool>,
        heightRatio: CGFloat,
        cornerRadius: CGFloat,
        backgroundColor: Color,
        dismissWhenBackgroundTapped: Bool
    ) {
        self._isPresented = isPresented
        self.heightRatio = heightRatio
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.dismissWhenBackgroundTapped = dismissWhenBackgroundTapped
    }
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if self.isPresented {
                    InMeetingSheetView(
                        isPresented: $isPresented,
                        heightRatio: self.heightRatio,
                        cornerRadius: self.cornerRadius,
                        backgroundColor: self.backgroundColor,
                        dismissWhenBackgroundTapped: self.dismissWhenBackgroundTapped
                    )
                    // 기본 transition 제거
                    .transition(.identity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: self.isPresented)
    }
}

extension View {
    
    func showInMeetingSheet(
        isPresented: Binding<Bool>,
        heightRatio: CGFloat = 0.9,
        cornerRadius: CGFloat = 20,
        backgroundColor: Color = .black.opacity(0.4),
        dismissWhenBackgroundTapped: Bool = true
    ) -> some View {
        
        self.modifier(
            InMeetingSheetModifier(
                isPresented: isPresented,
                heightRatio: heightRatio,
                cornerRadius: cornerRadius,
                backgroundColor: backgroundColor,
                dismissWhenBackgroundTapped: dismissWhenBackgroundTapped
            )
        )
    }
}
