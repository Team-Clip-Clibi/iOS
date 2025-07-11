//
//  NotificationViewModel.swift
//  OneThing
//
//  Created by 오현식 on 5/11/25.
//

import Foundation

// MARK: - 기존 뷰 모델

@Observable
class NotificationViewModel {

    struct State: Equatable {
        fileprivate(set) var unReadNotificationInfos: [NotificationInfo]
        fileprivate(set) var readNotificationInfos: [NotificationInfo]
        
        fileprivate(set) var isLoadMore: Bool
        
        var isNotificationEmpty: Bool {
            return self.unReadNotificationInfos.isEmpty && self.readNotificationInfos.isEmpty
        }
    }
    
    var currentState: State
    
    private let unReadNotificationUseCase: GetUnReadNotificationUseCase
    private let readNotificationUseCase: GetReadNotificationUseCase
    
    init(
        unReadNotificationUseCase: GetUnReadNotificationUseCase = GetUnReadNotificationUseCase(),
        readNotificationUseCase: GetReadNotificationUseCase = GetReadNotificationUseCase()
    ) {
        
        self.currentState = State(
            unReadNotificationInfos: [],
            readNotificationInfos: [],
            isLoadMore: true
        )
        
        self.unReadNotificationUseCase = unReadNotificationUseCase
        self.readNotificationUseCase = readNotificationUseCase
    }
    
    func notifications() async {
        do {
            let unReads = try await self.unReadNotificationUseCase.execute()
            let reads = try await self.readNotificationUseCase.execute()
            
            await MainActor.run {
                self.currentState.unReadNotificationInfos = unReads
                self.currentState.readNotificationInfos = reads
            }
        } catch {
            
            await MainActor.run {
                self.currentState.unReadNotificationInfos = []
                self.currentState.readNotificationInfos = []
            }
        }
    }
    
    func moreUnReadNotifications(with id: String) async {
        
        await MainActor.run {
            self.currentState.isLoadMore = true
        }
        
        do {
            let notifications = try await self.unReadNotificationUseCase.execute(with: id)
            
            await MainActor.run {
                self.currentState.unReadNotificationInfos.append(contentsOf: notifications)
                self.currentState.isLoadMore = false
            }
        } catch {
            
            await MainActor.run {
                self.currentState.isLoadMore = false
            }
        }
    }
    
    func moreReadNotifications(with id: String) async {
        
        await MainActor.run {
            self.currentState.isLoadMore = true
        }
        
        do {
            let notifications = try await self.readNotificationUseCase.execute(with: id)
            
            await MainActor.run {
                self.currentState.readNotificationInfos.append(contentsOf: notifications)
                self.currentState.isLoadMore = false
            }
        } catch {
            
            await MainActor.run {
                self.currentState.isLoadMore = false
            }
        }
    }
}


// MARK: - MVI 패턴으로 변경 후

@Observable
class NotificationStore: OTStore {
    
    struct State: OTState {
        fileprivate(set) var unReadNotificationInfos: [NotificationInfo]
        fileprivate(set) var readNotificationInfos: [NotificationInfo]
        
        fileprivate(set) var isLoadMore: Bool
        
        var isNotificationEmpty: Bool {
            return self.unReadNotificationInfos.isEmpty && self.readNotificationInfos.isEmpty
        }
    }
    
    var state: State
    
    private let unReadNotificationUseCase: GetUnReadNotificationUseCase
    private let readNotificationUseCase: GetReadNotificationUseCase
    
    init(
        unReadNotificationUseCase: GetUnReadNotificationUseCase = GetUnReadNotificationUseCase(),
        readNotificationUseCase: GetReadNotificationUseCase = GetReadNotificationUseCase()
    ) {
        
        self.state = State(
            unReadNotificationInfos: [],
            readNotificationInfos: [],
            isLoadMore: false
        )
        
        self.unReadNotificationUseCase = unReadNotificationUseCase
        self.readNotificationUseCase = readNotificationUseCase
    }
    
    enum Action: OTAction {
        case refresh
        case moreUnRead(String)
        case moreRead(String)
    }
    
    enum Process: OTProcess {
        case updateNotificationInfos([NotificationInfo])
        case updateUnReadNotificationInfos([NotificationInfo])
        case updateIsLoadMore(Bool)
    }
    
    func process(_ action: Action) async -> OTProcessResult<Process> {
        switch action {
        case .refresh:
            return await self.notifications()
        case let .moreUnRead(id):
            return .concat([
                .updateIsLoadMore(true),
                await self.moreUnReadNotifications(with: id) ?? .updateUnReadNotificationInfos([]),
                .updateIsLoadMore(false)
            ])
        case let .moreRead(id):
            return .concat([
                .updateIsLoadMore(true),
                await self.moreReadNotifications(with: id) ?? .updateNotificationInfos([]),
                .updateIsLoadMore(false)
            ])
        }
    }
    
    func reduce(state: State, process: Process) -> State {
        var newState = state
        switch process {
        case let .updateNotificationInfos(reads):
            if newState.readNotificationInfos.isEmpty {
                newState.readNotificationInfos = reads
            } else {
                newState.readNotificationInfos += reads
            }
        case let .updateUnReadNotificationInfos(unReads):
            if newState.unReadNotificationInfos.isEmpty {
                newState.unReadNotificationInfos = unReads
            } else {
                newState.unReadNotificationInfos += unReads
            }
        case let .updateIsLoadMore(isLoadMore):
            newState.isLoadMore = isLoadMore
        }
        return newState
    }
}

private extension NotificationStore {
    
    func notifications() async -> OTProcessResult<Process> {
        
        do {
            let unReads = try await self.unReadNotificationUseCase.execute()
            let reads = try await self.readNotificationUseCase.execute()
            
            return .concat([
                .updateUnReadNotificationInfos(unReads),
                .updateNotificationInfos(reads)
            ])
        } catch {
            
            return .concat([
                .updateUnReadNotificationInfos([]),
                .updateNotificationInfos([])
            ])
        }
    }
    
    func moreUnReadNotifications(with id: String) async -> Process? {
        
        do {
            let notifications = try await self.unReadNotificationUseCase.execute(with: id)
            
            return .updateUnReadNotificationInfos(notifications)
        } catch {
            
            return nil
        }
    }
    
    func moreReadNotifications(with id: String) async -> Process? {
        
        do {
            let notifications = try await self.readNotificationUseCase.execute(with: id)
            
            return .updateNotificationInfos(notifications)
        } catch {
            
            return nil
        }
    }
}
