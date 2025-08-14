//
//  AlertView.swift
//  OneThing
//
//  Created by 오현식 on 5/15/25.
//

import SwiftUI

struct AlertView: View {
    
    @Binding var isPresented: Bool
    
    let imageResource: ImageResource?
    let title: String
    let message: String
    let actions: [AlertAction]
    
    let dismissWhenBackgroundTapped: Bool
    
    var body: some View {
        
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
                .onTapGesture {
                    if self.dismissWhenBackgroundTapped { self.isPresented = false }
                }
            
            ZStack {
                VStack {
                    if let imageResource = self.imageResource {
                        Spacer().frame(height: 24)
                        
                        Image(imageResource)
                            .resizable()
                            .frame(width: 82, height: 82)
                    }
                    
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
        .background(ClearBackgroundView())
    }
    
    
}

private extension AlertView {
    
    func setupButtons(_ actions: [AlertAction]) -> some View {
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
    
    func button(_ action: AlertAction) -> some View {
        Button(
            action: { action.action() },
            label: {
                Text(action.title)
                    .otFont(.subtitle2)
                    .fontWeight(.semibold)
                    .foregroundStyle(action.foregroundColor)
            }
        )
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(action.backgrounColor)
        )
        .clipShape(.rect(cornerRadius: 12))
    }
}

extension AlertView {
    
    // 이미지 및 백그라운드 탭 액션이 없을 때
    init(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        actions: [AlertAction]
    ) {
        self._isPresented = isPresented
        self.imageResource = nil
        self.title = title
        self.message = message
        self.actions = actions
        self.dismissWhenBackgroundTapped = false
    }
    
    // 백그라운드 탭 액션만 없을 때
    init(
        isPresented: Binding<Bool>,
        imageResource: ImageResource,
        title: String,
        message: String,
        actions: [AlertAction]
    ) {
        self._isPresented = isPresented
        self.imageResource = imageResource
        self.title = title
        self.message = message
        self.actions = actions
        self.dismissWhenBackgroundTapped = false
    }
    
    // 이미지만 없을 때
    init(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        actions: [AlertAction],
        dismissWhenBackgroundTapped: Bool
    ) {
        self._isPresented = isPresented
        self.imageResource = nil
        self.title = title
        self.message = message
        self.actions = actions
        self.dismissWhenBackgroundTapped = dismissWhenBackgroundTapped
    }
}

#Preview {
    AlertView(
        isPresented: .constant(true),
        title: "원띵은 토스페이 결제만 가능해요",
        message: "토스 앱이 없다면, 설치 후 결제를 진행해주세요.",
        actions: [.init(title: "확인", style: .primary, action: { })]
    )
}
