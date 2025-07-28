//
//  AppDelegate.swift
//  OneThing
//
//  Created by 오현식 on 7/28/25.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        // Firebase 초기화
        FirebaseApp.configure()
        
        // UNUserNotificationCenter delegate 설정
        UNUserNotificationCenter.current().delegate = self
        
        // Firebase Messaging delegate 설정
        Messaging.messaging().delegate = self
        
        registerForPushNotifications()
        
        return true
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                LoggingManager.error("푸시 권한 요청 에러: \(error.localizedDescription)")
                return
            }
            
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                LoggingManager.error("푸시 권한 거부됨")
            }
        }
    }
    
    // APNS 등록 성공 시 호출: deviceToken을 Firebase Messaging에 전달
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // APNS 토큰 설정
        Messaging.messaging().apnsToken = deviceToken
        
        // 디버그용 APNS 토큰 출력
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let tokenString = tokenParts.joined()
        LoggingManager.info("APNS 토큰: \(tokenString)")
    }
    
    // APNS 등록 실패 시 호출
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        LoggingManager.error("원격 알림 등록 실패: \(error.localizedDescription)")
    }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    // APNS 토큰이 설정된 후 Firebase가 FCM 토큰을 갱신하면 호출됩니다.
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else { return }
        
        UserDefaults.standard.set(token, forKey: "firebaseToken")
        LoggingManager.info("Firebase FCM 토큰: \(token)")
    }
}
