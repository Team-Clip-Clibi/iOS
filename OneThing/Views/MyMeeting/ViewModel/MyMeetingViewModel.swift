//
//  MyMeetingViewModel.swift
//  OneThing
//
//  Created by 윤동주 on 5/20/25.
//

import SwiftUI

@Observable
class MyMeetingViewModel {
    
    // MARK: - Properties
    
    var isNotificationEnabled: Bool {
        NotificationManager.shared.isNotificationEnabled()
    }
    
    var matchingInfo: [MatchingInfo] = []

    private var updateUserNotifyUseCase: UpdateUserNotifyUseCase
    private let getMatchingsUseCase: GetMatchingsUseCase
    
    // MARK: - Initializer
    
    init(
        updateUserNotifyUseCase: UpdateUserNotifyUseCase = UpdateUserNotifyUseCase(),
        getMatchingsUseCase: GetMatchingsUseCase = GetMatchingsUseCase()
    ) {
        self.updateUserNotifyUseCase = updateUserNotifyUseCase
        self.getMatchingsUseCase = getMatchingsUseCase
    }
    
    // MARK: - Functions
    
    func updateNotification() async throws -> Bool {
        
        NotificationManager.shared.setNotificationEnabled(isEnabled: !isNotificationEnabled)
        
        return try await updateUserNotifyUseCase.execute(isAllowNotify: isNotificationEnabled)
    }
    
    func getAllMyMeeting() async throws {
//        self.matchingInfo =  try await getMatchingsUseCase.matchings()
        self.matchingInfo = 
        dump(matchingInfo)
    }
}
