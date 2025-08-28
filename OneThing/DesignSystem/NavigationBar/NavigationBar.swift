//
//  NavigationBar.swift
//  OneThing
//
//  Created by 오현식 on 5/9/25.
//

import SwiftUI

struct NavigationBar: View {
    
    /// 타이틀 텍스트
    var title: String?
    /// 타이틀 정렬 방식
    var titleAlignment: TitleAlignment = .center
    /// 커스텀 타이틀 뷰
    var titleView: AnyView?
    
    /// 뒤로 가기 버튼 숨김 여부
    var hidesBackButton: Bool = false
    /// 하단 구분 선 숨김 여부
    var hidesBottomSeparator: Bool = true
    /// 내부 여백
    var inset: EdgeInsets = EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
    /// 내부 요소들 사이의 간격
    var spacing: CGFloat = 0
    
    /// 좌측에 배치된 버튼 배열
    var leftButtons: [AnyView]?
    /// 우측에 배치된 버튼 배열
    var rightButtons: [AnyView]?
    
    var backgroundColor: Color = .white100
    
    /// 뒤로가기 버튼 액션
    var onBackButtonTap: (() -> Void)?
    
    var body: some View {
        
        ZStack {
            if self.titleAlignment == .center {
                // 중앙 영역 (타이틀)
                if let titleView = self.titleView {
                    titleView
                        .frame(maxWidth: .infinity, alignment: self.titleAlignment.toAlignment)
                } else if let title = self.title {
                    self.textTitleView(title)
                }
            }
            
            HStack(spacing: self.spacing) {
                // 왼쪽 영역 (뒤로가기 + 좌측 버튼들)
                HStack(spacing: self.spacing) {
                    if self.hidesBackButton == false {
                        self.backButton
                    }
                    
                    if let leftButtons = self.leftButtons, leftButtons.isEmpty == false {
                        ForEach(0..<leftButtons.count, id: \.self) { index in
                            leftButtons[index]
                        }
                    }
                }
                .frame(minWidth: 0)
                
                Spacer(minLength: self.spacing)
                
                if self.titleAlignment != .center {
                    if let titleView = self.titleView {
                        titleView
                            .frame(maxWidth: .infinity, alignment: self.titleAlignment.toAlignment)
                    } else if let title = self.title {
                        self.textTitleView(title)
                    }
                }
                
                Spacer(minLength: self.spacing)
                
                // 오른쪽 영역 (우측 버튼들)
                HStack(spacing: self.spacing) {
                    if let rightButtons = self.rightButtons, !rightButtons.isEmpty {
                        ForEach(0..<rightButtons.count, id: \.self) { index in
                            rightButtons[index]
                        }
                    }
                }
                .frame(minWidth: 0)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .padding(self.inset)
        .background(self.backgroundColor)
        .overlay(
            Rectangle()
                .frame(width: nil, height: self.hidesBottomSeparator ? 0: 1, alignment: .bottom)
                .foregroundStyle(.gray200),
            alignment: .bottom
        )
    }
    
    private var backButton: some View {
        Button(action: {
            self.onBackButtonTap?()
        }) {
            Image(.backButton)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.gray800)
        }
    }
    
    private func textTitleView(_ text: String) -> some View {
        Text(text)
            .otFont(.title1)
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(.black)
            .multilineTextAlignment(self.titleAlignment.toTextAlignment)
            .frame(maxWidth: .infinity, alignment: self.titleAlignment.toAlignment)
    }
}

extension NavigationBar {
    /// 타이틀 정렬 방식을 정의하는 열거형
    enum TitleAlignment {
        case left, center, right, fill
        
        var toTextAlignment: TextAlignment {
            switch self {
            case .left: return .leading
            case .right: return .trailing
            default: return .center
            }
        }
        
        var toAlignment: Alignment {
            switch self {
            case .left: return .leading
            case .right: return .trailing
            default: return .center
            }
        }
    }
}

#Preview {
    NavigationBar()
        .hidesBackButton(true)
        .titleView(
            Image(.logoBlack)
                .resizable()
                .scaledToFit()
                .frame(height: 24)
                
        )
        .titleAlignment(.left)
        .rightButtons([
            Button(action: { }, label: {
                Image(.bellUnread)
                    .resizable()
                    .frame(width: 24, height: 24)
            })
        ])
    
    NavigationBar()
        .title("알림")
        .hidesBottomSeparator(false)
}
