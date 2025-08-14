//
//  AlertAction.swift
//  OneThing
//
//  Created by 오현식 on 6/17/25.
//

import SwiftUI

struct AlertAction {
    
    enum Style {
        case primary
        case gray
    }
    
    typealias Action = () -> Void
    
    let tag = UUID()
    let title: String
    let style: Style
    let action: Action
    
    var foregroundColor: Color {
        switch self.style {
        case .primary:  return .white100
        case .gray:     return .gray800
        }
    }
    
    var backgrounColor: Color {
        switch self.style {
        case .primary:  return .purple400
        case .gray:     return .gray200
        }
    }
}

extension AlertAction: Equatable {
    
    static func == (lhs: AlertAction, rhs: AlertAction) -> Bool {
        return lhs.tag == rhs.tag
    }
}
