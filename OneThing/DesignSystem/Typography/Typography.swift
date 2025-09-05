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
    
    private(set) var font: Font
    private(set) var lineSpacing: CGFloat
    private(set) var letterSpacing: CGFloat
    private(set) var padding: CGFloat
    
    // 이니셜라이저: 폰트 사이즈, weight, lineHeight를 받아서 Typography 객체 생성
    init(size: CGFloat, weight: Font.Weight, lineHeight: CGFloat, letterSpacing: CGFloat = 0) {
        let fontName = Self.pretendardFontName(for: weight)
        let uiFont = UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
        let fontLineHeight = uiFont.lineHeight
        
        self.font = Font.custom(fontName, size: size)
        self.lineSpacing = max(0, lineHeight - fontLineHeight)
        self.letterSpacing = letterSpacing
        self.padding = max(0, (lineHeight - fontLineHeight) / 2)
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


// MARK: Weight

extension Typography {
    
    /// Size: 30, Line height: 42
    ///
    /// Weight: [Thin: 100, UltraLight: 200, Light: 300, Regular: 400, Medium: 500, SemiBold: 600, Bold: 700, Heavy: 800, Black: 900]
    static func heading1(with weight: Font.Weight) -> Typography {
        return Typography(size: 30, weight: weight, lineHeight: 42)
    }
    /// Size: 28, Line height: 40
    ///
    /// Weight: [Thin: 100, UltraLight: 200, Light: 300, Regular: 400, Medium: 500, SemiBold: 600, Bold: 700, Heavy: 800, Black: 900]
    static func heading2(with weight: Font.Weight) -> Typography {
        return Typography(size: 28, weight: weight, lineHeight: 40)
    }
    /// Size: 24, Line height: 34
    ///
    /// Weight: [Thin: 100, UltraLight: 200, Light: 300, Regular: 400, Medium: 500, SemiBold: 600, Bold: 700, Heavy: 800, Black: 900]
    static func heading3(with weight: Font.Weight) -> Typography {
        return Typography(size: 24, weight: weight, lineHeight: 34)
    }
    /// Size: 22, Line height: 30
    ///
    /// Weight: [Thin: 100, UltraLight: 200, Light: 300, Regular: 400, Medium: 500, SemiBold: 600, Bold: 700, Heavy: 800, Black: 900]
    static func heading4(with weight: Font.Weight) -> Typography {
        return Typography(size: 22, weight: weight, lineHeight: 30)
    }
    
    /// Size: 20, Line height: 28
    ///
    /// Weight: [Thin: 100, UltraLight: 200, Light: 300, Regular: 400, Medium: 500, SemiBold: 600, Bold: 700, Heavy: 800, Black: 900]
    static func title1(with weight: Font.Weight) -> Typography {
        return Typography(size: 20, weight: weight, lineHeight: 28)
    }
    
    /// Size: 18, Line height: 26
    ///
    /// Weight: [Thin: 100, UltraLight: 200, Light: 300, Regular: 400, Medium: 500, SemiBold: 600, Bold: 700, Heavy: 800, Black: 900]
    static func subtilte1(with weight: Font.Weight) -> Typography {
        return Typography(size: 18, weight: weight, lineHeight: 26)
    }
    /// Size: 16, Line height: 24
    ///
    /// Weight: [Thin: 100, UltraLight: 200, Light: 300, Regular: 400, Medium: 500, SemiBold: 600, Bold: 700, Heavy: 800, Black: 900]
    static func subtilte2(with weight: Font.Weight) -> Typography {
        return Typography(size: 16, weight: weight, lineHeight: 24)
    }
    
    /// Size: 14, Line height: 20
    ///
    /// Weight: [Thin: 100, UltraLight: 200, Light: 300, Regular: 400, Medium: 500, SemiBold: 600, Bold: 700, Heavy: 800, Black: 900]
    static func body1(with weight: Font.Weight) -> Typography {
        return Typography(size: 14, weight: weight, lineHeight: 20)
    }
    
    /// Size: 12, Line height: 18
    ///
    /// Weight: [Thin: 100, UltraLight: 200, Light: 300, Regular: 400, Medium: 500, SemiBold: 600, Bold: 700, Heavy: 800, Black: 900]
    static func caption1(with weight: Font.Weight) -> Typography {
        return Typography(size: 12, weight: weight, lineHeight: 18)
    }
    /// Size: 10, Line height: 14
    ///
    /// Weight: [Thin: 100, UltraLight: 200, Light: 300, Regular: 400, Medium: 500, SemiBold: 600, Bold: 700, Heavy: 800, Black: 900]
    static func caption2(with weight: Font.Weight) -> Typography {
        return Typography(size: 10, weight: weight, lineHeight: 14)
    }
}
