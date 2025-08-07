//
//  MyPageNotificationViewModel.swift
//  OneThing
//
//  Created by 윤동주 on 5/9/25.
//

import SwiftUI

@Observable
class MyPageNotificationViewModel {
    
    // MARK: - Properties
    
    var isNotificationEnabled: Bool {
        NotificationManager.shared.isNotificationEnabled()
    }

    private var updateUserNotifyUseCase: UpdateUserNotifyUseCase
    
    // MARK: - Initializer
    
    init(
        updateUserNotifyUseCase: UpdateUserNotifyUseCase = UpdateUserNotifyUseCase()
    ) {
        self.updateUserNotifyUseCase = updateUserNotifyUseCase
    }
    
    // MARK: - Functions
    
    func updateNotification() async throws -> Bool {
        
        NotificationManager.shared.setNotificationEnabled(isEnabled: !isNotificationEnabled)
        
        return try await updateUserNotifyUseCase.execute(isAllowNotify: isNotificationEnabled)
    }
}
