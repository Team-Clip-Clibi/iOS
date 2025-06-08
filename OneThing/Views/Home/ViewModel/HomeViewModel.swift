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
        fileprivate(set) var topBannerInfos: [NotificationBannerInfo]
        fileprivate(set) var isChangeSuccessForTopBannerStatus: Bool
        fileprivate(set) var noticeInfos: [NoticeInfo]
        fileprivate(set) var matchingSummaryInfos: [MatchingSummaryInfo]
        fileprivate(set) var bannerInfos: [BannerInfo]
        fileprivate(set) var isInMeeting: Bool
    }
    
    var currentState: State
    
    private let unReadNotificationUseCase: GetUnReadNotificationUseCase
    private let getNotificationBannerUseCase: GetNotificationBannerUseCase
    private let updateNotificationBannerUseCase: UpdateNotificationBannerUseCase
    private let noticeUseCase: GetNoticeUseCase
    private let matchingSummaryUseCase: GetMatchingSummaryUseCase
    private let meetingInProgressUseCase: GetMeetingInProgressUseCase
    private let bannerUseCase: GetBannerUseCase
    
    init(
        unReadNotificationUseCase: GetUnReadNotificationUseCase = GetUnReadNotificationUseCase(),
        getNotificationBannerUseCase: GetNotificationBannerUseCase = GetNotificationBannerUseCase(),
        updateNotificationBannerUseCase: UpdateNotificationBannerUseCase = UpdateNotificationBannerUseCase(),
        noticeUseCase: GetNoticeUseCase = GetNoticeUseCase(),
        matchingSummaryUseCase: GetMatchingSummaryUseCase = GetMatchingSummaryUseCase(),
        meetingInProgressUseCase: GetMeetingInProgressUseCase = GetMeetingInProgressUseCase(),
        bannerUseCase: GetBannerUseCase = GetBannerUseCase()
    ) {
        
        self.currentState = State(
            isUnReadNotificationEmpty: true,
            topBannerInfos: [],
            isChangeSuccessForTopBannerStatus: false,
            noticeInfos: [],
            matchingSummaryInfos: [],
            bannerInfos: [],
            isInMeeting: true
        )
        
        self.unReadNotificationUseCase = unReadNotificationUseCase
        self.getNotificationBannerUseCase = getNotificationBannerUseCase
        self.updateNotificationBannerUseCase = updateNotificationBannerUseCase
        self.noticeUseCase = noticeUseCase
        self.matchingSummaryUseCase = matchingSummaryUseCase
        self.meetingInProgressUseCase = meetingInProgressUseCase
        self.bannerUseCase = bannerUseCase
    }
    
    func isUnReadNotificationEmpty() async {
        do {
            self.currentState.isUnReadNotificationEmpty = try await self.unReadNotificationUseCase.isUnReadNotificationEmpty()
        } catch {
            self.currentState.isUnReadNotificationEmpty = true
        }
    }
    
    func topBanners() async {
        do {
            let topBannerInfos = try await self.getNotificationBannerUseCase.execute()
            
            await MainActor.run {
                self.currentState.topBannerInfos = topBannerInfos
                self.currentState.isChangeSuccessForTopBannerStatus = false
            }
        } catch {
            
            await MainActor.run {
                self.currentState.topBannerInfos = []
                self.currentState.isChangeSuccessForTopBannerStatus = false
            }
        }
    }
    
    func updateTopBannerStatus(with id: Int) async {
        do {
            let response = try await self.updateNotificationBannerUseCase.execute(with: id)
            
            await MainActor.run {
                self.currentState.isChangeSuccessForTopBannerStatus = response.statusCode == 200
            }
        } catch {
            
            await MainActor.run {
                self.currentState.isChangeSuccessForTopBannerStatus = false
            }
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
    
    func meetingInProgress() async {
        do {
            let response = try await self.meetingInProgressUseCase.execute()
            
            await MainActor.run {
                self.currentState.isInMeeting = response?.isToday == true
            }
        } catch {
            
            await MainActor.run {
                self.currentState.isInMeeting = false
            }
        }
    }
    
    func banners() async {
        do {
            self.currentState.bannerInfos = try await self.bannerUseCase.execute(with: .home)
        } catch {
            self.currentState.bannerInfos = []
        }
    }
}
