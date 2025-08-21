//
//  Typography.swift
//  OneThing
//
//  Created by 오현식 on 8/19/25.
//

import SwiftUI

struct Typography {
    
    // Pretendard 폰트의 weight와 파일명 매핑
    private static func pretendardFontName(for weight: Font.Weight) -> String {
        switch weight {
        case .thin: return "PretendardVariable-Thin"
        case .ultraLight: return "PretendardVariable-ExtraLight"
        case .light: return "PretendardVariable-Light"
        case .regular: return "PretendardVariable-Regular"
        case .medium: return "PretendardVariable-Medium"
        case .semibold: return "PretendardVariable-SemiBold"
        case .bold: return "PretendardVariable-Bold"
        case .heavy: return "PretendardVariable-ExtraBold"
        case .black: return "PretendardVariable-Black"
        default: return "PretendardVariable-Regular"
        }
    }
    
    var font: Font
    var uiFont: UIFont
    var lineHeight: CGFloat
    
    // 이니셜라이저: 폰트 사이즈, weight, lineHeight를 받아서 Typography 객체 생성
    init(size: CGFloat, weight: Font.Weight, lineHeight: CGFloat) {
        let fontName = Self.pretendardFontName(for: weight)
        self.font = .custom(fontName, size: size)
        self.uiFont = UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
        self.lineHeight = lineHeight
    }
}

extension Typography {
    
    static let heading1 = Typography(size: 30, weight: .bold, lineHeight: 42)
    static let heading2 = Typography(size: 28, weight: .bold, lineHeight: 40)
    static let heading3 = Typography(size: 24, weight: .bold, lineHeight: 34)
    static let heading4 = Typography(size: 22, weight: .bold, lineHeight: 30)
    
    static let title1 = Typography(size: 20, weight: .semibold, lineHeight: 28)
    
    static let subtitle1 = Typography(size: 18, weight: .semibold, lineHeight: 26)
    static let subtitle2 = Typography(size: 16, weight: .semibold, lineHeight: 24)
    
    static let body1 = Typography(size: 14, weight: .semibold, lineHeight: 20)
    static let body2 = Typography(size: 14, weight: .medium, lineHeight: 20)
    static let body3 = Typography(size: 14, weight: .regular, lineHeight: 20)
    
    static let caption1 = Typography(size: 12, weight: .semibold, lineHeight: 18)
    static let caption2 = Typography(size: 10, weight: .medium, lineHeight: 14)
}
