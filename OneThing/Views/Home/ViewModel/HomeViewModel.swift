//
//  HomeViewModel.swift
//  OneThing
//
//  Created by 윤동주 on 4/6/25.
//

import Foundation

@Observable
class HomeViewModel {
    
    struct State: Equatable {
        fileprivate(set) var isUnReadNotificationEmpty: Bool
        fileprivate(set) var noticeInfos: [NoticeInfo]
        fileprivate(set) var matchingSummaryInfos: [MatchingSummaryInfo]
    }
    
    var currentState: State
    
    private let unReadNotificationUseCase: GetUnReadNotificationUseCase
    private let noticeUseCase: GetNoticeUseCase
    private let matchingSummaryUseCase: GetMatchingSummaryUseCase
    
    init(
        unReadNotificationUseCase: GetUnReadNotificationUseCase = GetUnReadNotificationUseCase(),
        noticeUseCase: GetNoticeUseCase = GetNoticeUseCase(),
        matchingSummaryUseCase: GetMatchingSummaryUseCase = GetMatchingSummaryUseCase()
    ) {
        
        self.currentState = State(
            isUnReadNotificationEmpty: true,
            noticeInfos: [],
            matchingSummaryInfos: []
        )
        
        self.unReadNotificationUseCase = unReadNotificationUseCase
        self.noticeUseCase = noticeUseCase
        self.matchingSummaryUseCase = matchingSummaryUseCase
    }
    
    func isUnReadNotificationEmpty() async {
        do {
            self.currentState.isUnReadNotificationEmpty = try await self.unReadNotificationUseCase.isUnReadNotificationEmpty()
        } catch {
            self.currentState.isUnReadNotificationEmpty = true
        }
    }
    
    func notice() async {
        do {
            self.currentState.noticeInfos = try await self.noticeUseCase.execute()
        } catch {
            self.currentState.noticeInfos = []
        }
    }
    
    func matchingSummary() async {
        do {
            self.currentState.matchingSummaryInfos = try await self.matchingSummaryUseCase.execute()
        } catch {
            self.currentState.matchingSummaryInfos = []
        }
    }
}
