//
//  NotificationViewModel.swift
//  OneThing
//
//  Created by 오현식 on 5/11/25.
//

import Foundation

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
