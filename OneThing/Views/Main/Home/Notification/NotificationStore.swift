//
//  NotificationStore.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import Foundation

@Observable
class NotificationStore: OTStore {
    
    enum Action: OTAction {
        case refresh
        case moreForUnRead(String)
        case moreForRead(String)
    }
    
    enum Process: OTProcess {
        case notifications([NotificationInfo], [NotificationInfo])
        case moreFindForUnRead([NotificationInfo])
        case moreFindForRead([NotificationInfo])
        case updateIsLoading(Bool)
    }
    
    struct State: OTState {
        fileprivate(set) var unReadNotificationInfos: [NotificationInfo]
        fileprivate(set) var readNotificationInfos: [NotificationInfo]
        fileprivate(set) var isLoading: Bool
        
        var isNotificationEmpty: Bool {
            return self.unReadNotificationInfos.isEmpty && self.readNotificationInfos.isEmpty
        }
    }
    var state: State
    
    private let unReadNotificationUseCase: GetUnReadNotificationUseCase
    private let readNotificationUseCase: GetReadNotificationUseCase
    
    init(
        unReadNotificationUseCase: GetUnReadNotificationUseCase,
        readNotificationUseCase: GetReadNotificationUseCase
    ) {
        
        self.state = State(
            unReadNotificationInfos: [],
            readNotificationInfos: [],
            isLoading: false
        )
        
        self.unReadNotificationUseCase = unReadNotificationUseCase
        self.readNotificationUseCase = readNotificationUseCase
    }
    
    func process(_ action: Action) async -> OTProcessResult<Process> {
        switch action {
        case .refresh:
            return await self.notifications()
        case let .moreForUnRead(id):
            return .concat([
                .updateIsLoading(true),
                await self.moreUnReadNotifications(with: id),
                .updateIsLoading(false)
            ])
        case let .moreForRead(id):
            return .concat([
                .updateIsLoading(true),
                await self.moreReadNotifications(with: id),
                .updateIsLoading(false)
            ])
        }
    }
    
    func reduce(state: State, process: Process) -> State {
        var newState = state
        switch process {
        case let .notifications(unReads, reads):
            newState.unReadNotificationInfos = unReads
            newState.readNotificationInfos = reads
        case let .moreFindForUnRead(unReads):
            newState.unReadNotificationInfos += unReads
        case let .moreFindForRead(reads):
            newState.readNotificationInfos += reads
        case let .updateIsLoading(isLoading):
            newState.isLoading = isLoading
        }
        return newState
    }
}

private extension NotificationStore {
    
    func notifications() async -> OTProcessResult<Process> {
        do {
            let unReads = try await self.unReadNotificationUseCase.execute()
            let reads = try await self.readNotificationUseCase.execute()
            
            return .single(.notifications(unReads, reads))
        } catch {
            
            return .single(.notifications([], []))
        }
    }
    
    func moreUnReadNotifications(with id: String) async -> Process {
        
        do {
            let notifications = try await self.unReadNotificationUseCase.execute(with: id)
            return .moreFindForUnRead(notifications)
        } catch {
            return .moreFindForUnRead([])
        }
    }
    
    func moreReadNotifications(with id: String) async -> Process {
        do {
            let notifications = try await self.readNotificationUseCase.execute(with: id)
            return .moreFindForRead(notifications)
        } catch {
            return .moreFindForRead([])
        }
    }
}
