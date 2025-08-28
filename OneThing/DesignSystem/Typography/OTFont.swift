//
//  OTFont.swift
//  OneThing
//
//  Created by 윤동주 on 3/23/25.
//

import SwiftUI

enum FontStyle {
    case heading1, heading2, heading3, heading4
    case title1, subtitle1, subtitle2
    case body1, body2, body3
    case caption1, captionTwo
    
    var size: CGFloat {
        switch self {
        case .heading1: return 30
        case .heading2: return 28
        case .heading3: return 24
        case .heading4: return 22
        case .title1: return 20
        case .subtitle1: return 18
        case .subtitle2: return 16
        case .body1, .body2, .body3: return 14
        case .caption1: return 12
        case .captionTwo: return 10
        }
    }
    
    // 줄 높이
    var lineHeight: CGFloat {
        switch self {
        case .heading1: return 42
        case .heading2: return 40
        case .heading3: return 34
        case .heading4: return 30
        case .title1: return 28
        case .subtitle1: return 26
        case .subtitle2: return 24
        case .body1, .body2, .body3: return 20
        case .caption1: return 18
        case .captionTwo: return 14
        }
    }
    
    var weight: Font.Weight {
        switch self {
        case .heading1, .heading2, .heading3, .heading4:
            return .bold
        case .title1, .subtitle1, .subtitle2, .caption1, .body1:
            return .semibold
        case .body2, .captionTwo:
            return .medium
        case .body3:
            return .regular
        }
    }
    
    var font: Font {
        let name = FontStyle.fontName(for: weight)
        return Font.custom(name, size: size)
    }
    
    var lineSpacing: CGFloat {
        (lineHeight - size) / 2
    }
    
    private static func fontName(for weight: Font.Weight) -> String {
        switch weight {
        case .bold: return "Pretendard-Bold"
        case .semibold: return "Pretendard-SemiBold"
        case .medium: return "Pretendard-Medium"
        case .regular: return "Pretendard-Regular"
        default: return "Pretendard-Regular"
        }
    }
}


extension Font {
    static let heading1 = FontStyle.heading1.font
    static let heading2 = FontStyle.heading2.font
    static let heading3 = FontStyle.heading3.font
    static let heading4 = FontStyle.heading4.font
    
    static let title1 = FontStyle.title1.font
    static let subtitle1 = FontStyle.subtitle1.font
    static let subtitle2 = FontStyle.subtitle2.font
    
    static let body1 = FontStyle.body1.font
    static let body2 = FontStyle.body2.font
    static let body3 = FontStyle.body3.font
    
    static let caption1 = FontStyle.caption1.font
    static let captionTwo = FontStyle.captionTwo.font
}


struct PretendardModifier: ViewModifier {
    let style: FontStyle

    func body(content: Content) -> some View {
        content
            .font(style.font)
            .lineSpacing(style.lineSpacing)
    }
}

// extension View {
//     func otFont(_ style: FontStyle) -> some View {
//         self.modifier(PretendardModifier(style: style))
//     }
// }
