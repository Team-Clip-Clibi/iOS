//
//  InMeetingSheet+Modifier.swift
//  OneThing
//
//  Created by 오현식 on 6/5/25.
//

import SwiftUI

struct InMeetingSheetModifier: ViewModifier {
    
    @Binding var inMeetingPathManager: OTInMeetingPathManager
    @Binding var inMeetingViewModel: InMeetingViewModel
    @Binding var isPresented: Bool
    
    let heightRatio: CGFloat
    let cornerRadius: CGFloat
    let backgroundColor: Color
    let dismissWhenBackgroundTapped: Bool
    
    init(
        inMeetingPathManager: Binding<OTInMeetingPathManager>,
        inMeetingViewModel: Binding<InMeetingViewModel>,
        isPresented: Binding<Bool>,
        heightRatio: CGFloat,
        cornerRadius: CGFloat,
        backgroundColor: Color,
        dismissWhenBackgroundTapped: Bool
    ) {
        self._inMeetingPathManager = inMeetingPathManager
        self._inMeetingViewModel = inMeetingViewModel
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
                        inMeetingPathManager: $inMeetingPathManager,
                        inMeetingViewModel: $inMeetingViewModel,
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
        inMeetingPathManager: Binding<OTInMeetingPathManager>,
        inMeetingVieWModel: Binding<InMeetingViewModel>,
        isPresented: Binding<Bool>,
        heightRatio: CGFloat = 0.9,
        cornerRadius: CGFloat = 20,
        backgroundColor: Color = .black.opacity(0.4),
        dismissWhenBackgroundTapped: Bool = true
    ) -> some View {
        
        self.modifier(
            InMeetingSheetModifier(
                inMeetingPathManager: inMeetingPathManager,
                inMeetingViewModel: inMeetingVieWModel,
                isPresented: isPresented,
                heightRatio: heightRatio,
                cornerRadius: cornerRadius,
                backgroundColor: backgroundColor,
                dismissWhenBackgroundTapped: dismissWhenBackgroundTapped
            )
        )
    }
}
