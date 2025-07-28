//
//  AlertView+Modifier.swift
//  OneThing
//
//  Created by 오현식 on 6/17/25.
//

import SwiftUI


struct AlertModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    
    let imageResource: ImageResource?
    let title: String
    let message: String
    let actions: [AlertAction]
    
    let dismissWhenBackgroundTapped: Bool
    
    var completion: (() -> Void)?
    
    init(
        isPresented: Binding<Bool>,
        imageResource: ImageResource? = nil,
        title: String,
        message: String,
        actions: [AlertAction],
        dismissWhenBackgroundTapped: Bool = false,
        completion: (() -> Void)? = nil
    ) {
        self._isPresented = isPresented
        self.imageResource = imageResource
        self.title = title
        self.message = message
        self.actions = actions
        self.dismissWhenBackgroundTapped = dismissWhenBackgroundTapped
    }
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented, onDismiss: self.completion) {
                AlertView(
                    isPresented: $isPresented,
                    imageResource: self.imageResource,
                    title: self.title,
                    message: self.message,
                    actions: self.actions,
                    dismissWhenBackgroundTapped: self.dismissWhenBackgroundTapped
                )
            }
            .transaction { $0.disablesAnimations = true }
    }
}

extension View {
    
    // 이미지 및 백그라운드 탭 액션이 없을 때
    func showAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        actions: [AlertAction]
    ) -> some View {
        
        self.modifier(
            AlertModifier(
                isPresented: isPresented,
                title: title,
                message: message,
                actions: actions
            )
        )
    }
    
    // 백그라운드 탭 액션만 없을 때
    func showAlert(
        isPresented: Binding<Bool>,
        imageResource: ImageResource,
        title: String,
        message: String,
        actions: [AlertAction]
    ) -> some View {
        
        self.modifier(
            AlertModifier(
                isPresented: isPresented,
                imageResource: imageResource,
                title: title,
                message: message,
                actions: actions
            )
        )
    }
    
    // 이미지만 없을 때
    func showAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        actions: [AlertAction],
        dismissWhenBackgroundTapped: Bool
    ) -> some View {
        
        self.modifier(
            AlertModifier(
                isPresented: isPresented,
                title: title,
                message: message,
                actions: actions,
                dismissWhenBackgroundTapped: dismissWhenBackgroundTapped
            )
        )
    }
}
