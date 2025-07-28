//
//  AlertView+Static.swift
//  OneThing
//
//  Created by 오현식 on 6/17/25.
//

import SwiftUI

extension View {
    
    func showPreparing(isPresented: Binding<Bool>) -> some View {
        
        let title: String = "서비스 준비 중이에요"
        let message: String = "빠른 시일내에 준비하여 찾아뵐게요"
        let confirmButtonTitle: String = "확인"
        
        let action = AlertAction(
            title: confirmButtonTitle,
            style: .primary,
            action: { isPresented.wrappedValue = false }
        )
        
        return self.modifier(
            AlertModifier(
                isPresented: isPresented,
                imageResource: .comingsoon,
                title: title,
                message: message,
                actions: [action],
                dismissWhenBackgroundTapped: true
            )
        )
    }
}
