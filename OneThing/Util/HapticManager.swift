//
//  HapticManager.swift
//  OneThing
//
//  Created by 윤동주 on 5/11/25.
//

import SwiftUI

final class HapticManager {
    
    // MARK: - Properties

    private(set) var isEnable: Bool {
        get{ UserDefaults.standard.bool(forKey: "haptic") }
        set{ UserDefaults.standard.setValue(newValue, forKey: "haptic") }
    }
    
    static let shared = HapticManager()
    
    // MARK: - Initializer

    private init() {}
    
    func setEnable(_ isEnable: Bool) {
        self.isEnable = isEnable
    }
    
    /// Notification Style - warning / error / success
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        guard isEnable else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    /// Impact Style - heavy / light / medium / rigid / soft
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle,
                intensity: CGFloat = 1.0) {
        guard isEnable else {return}
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred(intensity: intensity)
    }
}
