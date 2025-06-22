//
//  AlertAction.swift
//  OneThing
//
//  Created by 오현식 on 6/17/25.
//

import Foundation

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
