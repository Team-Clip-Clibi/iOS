//
//  OTBaseView.swift
//  OneThing
//
//  Created by 오현식 on 7/26/25.
//

import SwiftUI

struct OTBaseView<Content: View>: View {
    
    private(set) var name: String
    private(set) var backgroundColor: Color
    private(set) var isEndEditingWhenOnDisappear: Bool
    
    var updateKeyboard: ((CGFloat) -> Void)?
    
    let content: Content
    init(
        _ name: String,
        background: Color = .white100,
        isEndEditingWhenOnDisappear: Bool = true,
        updateKeyboard: ((CGFloat) -> Void)? = nil,
        @ViewBuilder _ content: (() -> Content)
    ) {
        self.name = name
        self.backgroundColor = background
        self.isEndEditingWhenOnDisappear = isEndEditingWhenOnDisappear
        self.content = content()
    }
    
    var body: some View {
        
        self.content
            .navigationBarBackButtonHidden()
            .background(self.backgroundColor)
            .onAppear {
                LoggingManager.info("OnAppear View: \(self.name)")
            }
            .onDisappear {
                LoggingManager.info("OnDisappear View: \(self.name)")
                if self.isEndEditingWhenOnDisappear {
                    UIApplication.shared.endEditing()
                }
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .onReceive(
                NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            ) { noti in
                if let height = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height {
                    self.updateKeyboard?(height)
                }
            }
            .onReceive(
                NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            ) { _ in
                self.updateKeyboard?(.zero)
            }
    }
}
