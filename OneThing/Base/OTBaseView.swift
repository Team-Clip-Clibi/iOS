//
//  OTBaseView.swift
//  OneThing
//
//  Created by 오현식 on 7/26/25.
//

import SwiftUI

struct OTBaseView<Content: View>: View {
    
    private(set) var isEndEditingWhenOnDisappear: Bool
    
    var updateKeyboard: ((CGFloat) -> Void)?
    
    let content: Content
    init(
        isEndEditingWhenOnDisappear: Bool = true,
        updateKeyboard: ((CGFloat) -> Void)? = nil,
        @ViewBuilder _ content: (() -> Content)
    ) {
        self.content = content()
        self.isEndEditingWhenOnDisappear = isEndEditingWhenOnDisappear
    }
    
    var body: some View {
        
        self.content
            .ignoresSafeArea()
            .frame(width: .infinity, height: .infinity)
            .background(.white100)
            .onAppear {
                LoggingManager.info("OnAppear View: \(type(of: self))")
            }
            .onDisappear {
                LoggingManager.info("OnDisappear View: \(type(of: self))")
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
            .onPreferenceChange(HidesBottomBarWhenPushedKey.self) { value in
                NotificationCenter.default.post(
                    name: .hidesBottomBarWhenPushed,
                    object: ["hidesBottomBarWhenPushed": value]
                )
            }
    }
}

extension OTBaseView {
    
    func backgroundColor(_ color: Color) -> some View {
        self.background(color)
    }
    
    func hidesBottomBarWhenPushed(_ hidesBottomBarWhenPushed: Bool = true) -> some View {
        self.preference(key: HidesBottomBarWhenPushedKey.self, value: hidesBottomBarWhenPushed)
    }
}

struct HidesBottomBarWhenPushedKey: PreferenceKey {
    static let defaultValue: Bool = false
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}
