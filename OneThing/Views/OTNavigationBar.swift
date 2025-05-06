//
//  OTNavigationBar.swift
//  OneThing
//
//  Created by 윤동주 on 3/30/25.
//

import SwiftUI

struct OTNavigationBar: View {
    var leftButtonType: LeftButtonType = .none
    var rightButtonType: RightButtonType = .none
    var title: String
    var phase: Int = 0
    
    var leftAction: () -> Void = {}
    var rightAction: () -> Void = {}
    
    var body: some View {
        HStack {
            Button(action: leftAction) {
                switch leftButtonType {
                case .back:
                    Image("backButton")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.gray800)
                        .frame(width: 24, height: 24)
                case .none:
                    EmptyView()
                }
            }
            
            Spacer()
            
            Text(title)
                .otFont(.title1)
                .fontWeight(.semibold)
                .foregroundStyle(.black)
            
            Spacer()
            
            if phase == 0 {
                Button(action: rightAction) {
                    switch rightButtonType {
                    case .close:
                        Image(.closeButton)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.gray500)
                            .frame(width: 14, height: 14)
                    case .none:
                        EmptyView()
                    }
                }
                .frame(width: 24, height: 24)
            } else {
                Text("\(String(phase))/4")
                    .otFont(.caption1)
                    .fontWeight(.semibold)
                    .foregroundStyle(.purple400)
                    .frame(width: 24, height: 24)
            }
            
        }
        .padding(.horizontal, 15)
        .frame(maxWidth: .infinity, minHeight: 48)
        .overlay(
            Rectangle()
                .fill(.gray200)
                .frame(height: 1),
            alignment: .bottom
        )
    }
}

extension OTNavigationBar {
    enum LeftButtonType {
        case back
        case none
    }
    
    enum RightButtonType {
        case close
        case none
    }
}

#Preview {
    OTNavigationBar(
        leftButtonType: .back,
        rightButtonType: .none,
        title: "회원가입", phase: 3,
        leftAction: { print("Left button tapped") },
        rightAction: { print("Right button tapped") }
    )
}
