//
//  AlertView.swift
//  OneThing
//
//  Created by 오현식 on 5/15/25.
//

import SwiftUI

struct AlertAction {
    
    enum Style {
        case confirm
    }
    
    typealias Action = () -> Void
    
    let tag = UUID()
    let title: String
    let style: Style
    let action: Action
}

extension AlertAction: Equatable {
    
    static func == (lhs: AlertAction, rhs: AlertAction) -> Bool {
        return lhs.tag == rhs.tag
    }
}

struct AlertView: View {
    
    private(set) var title: String
    private(set) var message: String
    private(set) var actions: [AlertAction]
    
    private(set) var dismissWhenBackgroundTapped: (() -> Void)?
    
    var body: some View {
        
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
                .onTapGesture {
                    self.dismissWhenBackgroundTapped?()
                }
            
            ZStack {
                VStack {
                    Spacer().frame(height: 24)
                    
                    Text(self.title)
                        .otFont(.title1)
                        .foregroundStyle(.gray800)
                        .multilineTextAlignment(.center)
                    
                    Spacer().frame(height: 6)
                    
                    Text(self.message)
                        .otFont(.body1)
                        .foregroundStyle(.gray600)
                        .multilineTextAlignment(.center)
                    
                    Spacer().frame(height: 24)
                    
                    self.setupButtons(self.actions)
                    
                    Spacer().frame(height: 24)
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity)
                .background(.white100)
                .clipShape(.rect(cornerRadius: 24))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(.gray100, lineWidth: 1)
                )
            }
            .padding(.horizontal, 35)
        }
    }
    
    private func setupButtons(_ actions: [AlertAction]) -> some View {
        VStack(spacing: 10) {
            ForEach(actions, id: \.tag) { action in
                OTMButton(
                    buttonTitle: action.title,
                    action: { action.action() },
                    isClickable: true
                )
                .tag(action.tag)
            }
        }
    }
}

#Preview {
    AlertView(
        title: "원띵은 토스페이 결제만 가능해요",
        message: "토스 앱이 없다면, 설치 후 결제를 진행해주세요.",
        actions: [.init(title: "확인", style: .confirm, action: { })]
    )
}
