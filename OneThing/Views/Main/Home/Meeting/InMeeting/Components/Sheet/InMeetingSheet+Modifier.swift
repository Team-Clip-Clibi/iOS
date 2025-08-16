//
//  InMeetingSheet+Modifier.swift
//  OneThing
//
//  Created by 오현식 on 6/5/25.
//

import SwiftUI

struct InMeetingSheetModifier<SheetContent: View>: ViewModifier {
    
    @Binding var isPresented: Bool
    
    let heightRatio: CGFloat
    let cornerRadius: CGFloat
    let backgroundColor: Color
    let dismissWhenBackgroundTapped: Bool
    
    let sheetContent: (() -> SheetContent)
    
    init(
        isPresented: Binding<Bool>,
        heightRatio: CGFloat,
        cornerRadius: CGFloat,
        backgroundColor: Color,
        dismissWhenBackgroundTapped: Bool,
        @ViewBuilder sheetContent: @escaping (() -> SheetContent)
    ) {
        self._isPresented = isPresented
        self.heightRatio = heightRatio
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.dismissWhenBackgroundTapped = dismissWhenBackgroundTapped
        self.sheetContent = sheetContent
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
                        dismissWhenBackgroundTapped: self.dismissWhenBackgroundTapped,
                        content: self.sheetContent
                    )
                    // 기본 transition 제거
                    .transition(.identity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: self.isPresented)
    }
}

extension View {
    
    func showInMeetingSheet<Content: View>(
        isPresented: Binding<Bool>,
        heightRatio: CGFloat = 0.9,
        cornerRadius: CGFloat = 20,
        backgroundColor: Color = .black.opacity(0.4),
        dismissWhenBackgroundTapped: Bool = true,
        @ViewBuilder content: @escaping (() -> Content)
    ) -> some View {
        
        self.modifier(
            InMeetingSheetModifier(
                isPresented: isPresented,
                heightRatio: heightRatio,
                cornerRadius: cornerRadius,
                backgroundColor: backgroundColor,
                dismissWhenBackgroundTapped: dismissWhenBackgroundTapped,
                sheetContent: content
            )
        )
    }
}
