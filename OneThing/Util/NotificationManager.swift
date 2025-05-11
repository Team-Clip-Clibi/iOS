//
//  NotificationManager.swift
//  OneThing
//
//  Created by 윤동주 on 5/9/25.
//

import Foundation
import SwiftUI
import UserNotifications

enum NotificationManagerError: Error {
    case cannotRequestNotificationAuthorization
}

class NotificationManager {
    
    // MARK: - Properties
    
    static let shared = NotificationManager()
    
    // MARK: - Initializer
    
    private init() {}
    
    // MARK: - Functions
    
    /// Notiification에 대한 권한 설정을 요청합니다.
    func requestAuthorization() async throws {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        // 초기 설정이라면,
        // 시스템 알림 설정과 동일하게 내부 알림 여부(UserDefaults) 값을 결정합니다.
        do {
            let result = try await UNUserNotificationCenter.current().requestAuthorization(options: options)
            if UserDefaults.standard.object(forKey: "notificationEnabled") == nil {
                NotificationManager.shared.setNotificationEnabled(isEnabled: result)
            }
        } catch {
            throw NotificationManagerError.cannotRequestNotificationAuthorization
        }
    }
    
    /// Notification 권한 허용 여부를 확인하고 거부가 되어 있을 시 설정창으로 이동합니다.
    func checkAuthorizationStatus() async throws {
        let status = await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                continuation.resume(returning: settings.authorizationStatus)
            }
        }
        switch status {
        /// Push Notification에 대한 권한이 없을 시 설정 화면으로 이동합니다.
        case .notDetermined, .denied:
            openSettings()
        case .authorized, .provisional, .ephemeral:
            return
        @unknown default:
            return
        }
    }
    
    /// 설정창으로 이동합니다.
    func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsURL) {
            Task { @MainActor in
                UIApplication.shared.open(settingsURL)
            }
        }
    }
    
    /// Notification을 생성 후 등록합니다.
    func scheduleNotification() {
        
    }
    
    /// Notification을 취소합니다.
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    /// Notification 활성화 여부를 확인합니다.
    func isNotificationEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: "notificationEnabled")
    }
    
    /// Notification 활성화 상태를 설정합니다.
    func setNotificationEnabled(isEnabled: Bool) {
        UserDefaults.standard.set(isEnabled, forKey: "notificationEnabled")
    }
}
