//
//  OTFont.swift
//  OneThing
//
//  Created by 윤동주 on 3/23/25.
//

import SwiftUI

enum FontStyle {
    case heading1, heading2, heading3
    case title1, subtitle1, subtitle2
    case body1, body2
    case caption1, caption2

    var size: CGFloat {
        switch self {
        case .heading1: return 30
        case .heading2: return 28
        case .heading3: return 24
        case .title1: return 20
        case .subtitle1: return 18
        case .subtitle2: return 16
        case .body1, .body2: return 14
        case .caption1: return 12
        case .caption2: return 10
        }
    }

    var weight: Font.Weight {
        switch self {
        case .heading1, .heading2, .heading3:
            return .bold
        case .title1, .subtitle1, .subtitle2, .caption1:
            return .semibold
        case .body1, .caption2:
            return .medium
        case .body2:
            return .regular
        }
    }

    var font: Font {
        let name = FontStyle.fontName(for: weight)
        return Font.custom(name, size: size)
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

    static let title1 = FontStyle.title1.font
    static let subtitle1 = FontStyle.subtitle1.font
    static let subtitle2 = FontStyle.subtitle2.font

    static let body1 = FontStyle.body1.font
    static let body2 = FontStyle.body2.font

    static let caption1 = FontStyle.caption1.font
    static let caption2 = FontStyle.caption2.font
}
