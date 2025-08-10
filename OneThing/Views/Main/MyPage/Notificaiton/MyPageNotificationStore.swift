//
//  MyPageNotificationStore.swift
//  OneThing
//
//  Created by 오현식 on 8/9/25.
//

import Foundation

@Observable
class MyPageNotificationStore: OTStore {
    
    enum Action: OTAction {
        case updateNotificationEnabled(Bool)
    }
    
    enum Process: OTProcess {
        case updateNotificationEnabled(Bool)
    }
    
    struct State: OTState {
        fileprivate(set) var isNotificationEnabled: Bool
        fileprivate(set) var isNotificationUpdated: Bool
    }
    var state: State
    
    private var updateUserNotifyUseCase: UpdateUserNotifyUseCase
    
    init(updateUserNotifyUseCase: UpdateUserNotifyUseCase) {
        let isNotificationEnabled = NotificationManager.shared.isNotificationEnabled()
        
        self.state = State(
            isNotificationEnabled: isNotificationEnabled,
            isNotificationUpdated: false
        )
        
        self.updateUserNotifyUseCase = updateUserNotifyUseCase
    }
    
    func process(_ action: Action) async -> OTProcessResult<Process> {
        switch action {
        case let .updateNotificationEnabled(isNotificationEnabled):
            return .single(.updateNotificationEnabled(isNotificationEnabled))
        }
    }
    
    func reduce(state: State, process: Process) -> State {
        var newState = state
        switch process {
        case let .updateNotificationEnabled(isNotificationUpdated):
            newState.isNotificationUpdated = isNotificationUpdated
        }
        return newState
    }
}

private extension MyPageNotificationStore {
    
    func updateNotificatinoEnabled(
        _ isNotificationEnabled: Bool
    ) async -> OTProcessResult<Process> {
        
        do {
            let isNotificationUpdated = try await self.updateUserNotifyUseCase.execute(
                isAllowNotify: isNotificationEnabled
            )
            
            NotificationManager.shared.setNotificationEnabled(isEnabled: isNotificationEnabled)
            
            return .single(.updateNotificationEnabled(isNotificationUpdated))
        } catch {
            
            return .single(.updateNotificationEnabled(false))
        }
    }
}
