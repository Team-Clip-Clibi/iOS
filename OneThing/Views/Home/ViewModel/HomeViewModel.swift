//
//  HomeViewModel.swift
//  OneThing
//
//  Created by 윤동주 on 4/6/25.
//

import SwiftUI

@Observable
class HomeViewModel {
    
    struct State: Equatable {
        fileprivate(set) var nickname: String
        fileprivate(set) var isUnReadNotificationEmpty: Bool
        fileprivate(set) var topBannerInfos: [NotificationBannerInfo]
        fileprivate(set) var isChangeSuccessForTopBannerStatus: Bool
        fileprivate(set) var noticeInfos: [NoticeInfo]
        fileprivate(set) var matchingSummaryInfos: [MatchingSummaryInfo]
        fileprivate(set) var bannerInfos: [HomeBannerInfo]
        fileprivate(set) var meetingDate: Date?
        fileprivate(set) var inMeetingInfo: InMeetingInfo?
        fileprivate(set) var isInMeeting: Bool
    }
    
    var currentState: State
    
    // TODO: 임시, 유저 정보는 전역으로 관리 필요
    private let getProfileUseCase: GetProfileInfoUseCase
    private let unReadNotificationUseCase: GetUnReadNotificationUseCase
    private let getNotificationBannerUseCase: GetNotificationBannerUseCase
    private let updateNotificationBannerUseCase: UpdateNotificationBannerUseCase
    private let noticeUseCase: GetNoticeUseCase
    private let matchingSummaryUseCase: GetMatchingSummaryUseCase
    private let meetingInProgressUseCase: GetMeetingInProgressUseCase
    private let bannerUseCase: GetBannerUseCase
    
    init(
        getProfileUseCase: GetProfileInfoUseCase = GetProfileInfoUseCase(),
        unReadNotificationUseCase: GetUnReadNotificationUseCase = GetUnReadNotificationUseCase(),
        getNotificationBannerUseCase: GetNotificationBannerUseCase = GetNotificationBannerUseCase(),
        updateNotificationBannerUseCase: UpdateNotificationBannerUseCase = UpdateNotificationBannerUseCase(),
        noticeUseCase: GetNoticeUseCase = GetNoticeUseCase(),
        matchingSummaryUseCase: GetMatchingSummaryUseCase = GetMatchingSummaryUseCase(),
        meetingInProgressUseCase: GetMeetingInProgressUseCase = GetMeetingInProgressUseCase(),
        bannerUseCase: GetBannerUseCase = GetBannerUseCase()
    ) {
        
        self.currentState = State(
            nickname: "",
            isUnReadNotificationEmpty: true,
            topBannerInfos: [],
            isChangeSuccessForTopBannerStatus: false,
            noticeInfos: [],
            matchingSummaryInfos: [],
            bannerInfos: [],
            meetingDate: nil,
            inMeetingInfo: nil,
            isInMeeting: false
        )
        
        self.getProfileUseCase = getProfileUseCase
        self.unReadNotificationUseCase = unReadNotificationUseCase
        self.getNotificationBannerUseCase = getNotificationBannerUseCase
        self.updateNotificationBannerUseCase = updateNotificationBannerUseCase
        self.noticeUseCase = noticeUseCase
        self.matchingSummaryUseCase = matchingSummaryUseCase
        self.meetingInProgressUseCase = meetingInProgressUseCase
        self.bannerUseCase = bannerUseCase
    }
    
    func profile() async {
        do {
            let profileInfo = try await self.getProfileUseCase.execute()
            
            await MainActor.run {
                self.currentState.nickname = profileInfo.nickname
            }
        } catch {
            await MainActor.run {
                self.currentState.nickname = ""
            }
        }
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
                self.currentState.meetingDate = response.meetingDate
                self.currentState.inMeetingInfo = response.inMeetingInfo
            }
        } catch {
            
            await MainActor.run {
                self.currentState.meetingDate = nil
                self.currentState.inMeetingInfo = nil
            }
        }
    }
    
    // TODO: 임시, 모임 중 바텀 싯 표시할 플로팅 뷰 표시 플래그
    func updateIsInMeeting(_ isInMeeting: Bool) async {
        await MainActor.run {
            self.currentState.isInMeeting = isInMeeting
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

extension HomeViewModel {
    
    func viewModelForInMeeting() -> Binding<InMeetingViewModel> {
        
        if let inMeetingInfo = self.currentState.inMeetingInfo {
            
            return .constant(
                InMeetingViewModel(inMeetingInfo: inMeetingInfo)
            )
        } else {
            
            return .constant(
                InMeetingViewModel(
                    inMeetingInfo: InMeetingInfo(
                        matchingId: "",
                        matchingType: .oneThing,
                        nicknameList: [],
                        quizList: [],
                        oneThingMap: [:]
                    )
                )
            )
        }
    }
}
