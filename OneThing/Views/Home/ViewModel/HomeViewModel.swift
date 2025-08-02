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
        fileprivate(set) var matchingSummariesWithType: [MatchingSummariesWithType]
        fileprivate(set) var bannerInfos: [HomeBannerInfo]
        fileprivate(set) var matchingProgressInfo: [MatchingInfo]
        fileprivate(set) var hasMeeting: [MatchingInfo]
        fileprivate(set) var shouldWriteReview: [MatchingInfo]
        fileprivate(set) var reachedMeeting: MatchingInfo?
        // TODO: 임시, 모임 후기 용
        fileprivate(set) var meetingReviewInfo: MeetingReviewViewModel.InitialInfo?
        
        fileprivate(set) var isLoading: Bool
    }
    
    var currentState: State
    
    // TODO: 임시, 유저 정보는 전역으로 관리 필요
    private let getProfileUseCase: GetProfileInfoUseCase
    private let getUnReadNotificationUseCase: GetUnReadNotificationUseCase
    private let getNotificationBannerUseCase: GetNotificationBannerUseCase
    private let updateNotificationBannerUseCase: UpdateNotificationBannerUseCase
    private let noticeUseCase: GetNoticeUseCase
    private let getMatchingStatusUseCase: GetMatchingStatusUseCase
    private let getMatchingsUseCase: GetMatchingsUseCase
    private let bannerUseCase: GetBannerUseCase
    
    init(
        getProfileUseCase: GetProfileInfoUseCase = GetProfileInfoUseCase(),
        getUnReadNotificationUseCase: GetUnReadNotificationUseCase = GetUnReadNotificationUseCase(),
        getNotificationBannerUseCase: GetNotificationBannerUseCase = GetNotificationBannerUseCase(),
        updateNotificationBannerUseCase: UpdateNotificationBannerUseCase = UpdateNotificationBannerUseCase(),
        noticeUseCase: GetNoticeUseCase = GetNoticeUseCase(),
        getMatchingStatusUseCase: GetMatchingStatusUseCase = GetMatchingStatusUseCase(),
        getMatchingsUseCase: GetMatchingsUseCase = GetMatchingsUseCase(),
        bannerUseCase: GetBannerUseCase = GetBannerUseCase()
    ) {
        
        self.currentState = State(
            nickname: "",
            isUnReadNotificationEmpty: true,
            topBannerInfos: [],
            isChangeSuccessForTopBannerStatus: false,
            noticeInfos: [],
            matchingSummariesWithType: [],
            bannerInfos: [],
            matchingProgressInfo: [],
            hasMeeting: [],
            shouldWriteReview: [],
            reachedMeeting: nil,
            meetingReviewInfo: nil,
            isLoading: false
        )
        
        self.getProfileUseCase = getProfileUseCase
        self.getUnReadNotificationUseCase = getUnReadNotificationUseCase
        self.getNotificationBannerUseCase = getNotificationBannerUseCase
        self.updateNotificationBannerUseCase = updateNotificationBannerUseCase
        self.noticeUseCase = noticeUseCase
        self.getMatchingStatusUseCase = getMatchingStatusUseCase
        self.getMatchingsUseCase = getMatchingsUseCase
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
            self.currentState.isUnReadNotificationEmpty = try await self.getUnReadNotificationUseCase.execute().isEmpty
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
    
    func updateTopBannerStatus(with id: String) async {
        do {
            let isSuccess = try await self.updateNotificationBannerUseCase.execute(with: id)
            
            await MainActor.run {
                self.currentState.isChangeSuccessForTopBannerStatus = isSuccess
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
    
    func matchingSummaries() async {
        do {
            let matchingSummariesInfo = try await self.getMatchingStatusUseCase.matchingsSummaries()
            
            await MainActor.run {
                var matchingSummariesWithType: [MatchingSummariesWithType] {
                    let fromOnethings = matchingSummariesInfo.onethings.map {
                        MatchingSummariesWithType(type: .onething, info: $0)
                    }
                    let fromRandoms = matchingSummariesInfo.randoms.map {
                        MatchingSummariesWithType(type: .random, info: $0)
                    }
                    
                    return fromOnethings + fromRandoms
                }
                self.currentState.matchingSummariesWithType = matchingSummariesWithType
            }
        } catch {
            await MainActor.run {
                self.currentState.matchingSummariesWithType = []
            }
        }
    }
    
    func matchings() async {
        do {
            let response = try await self.getMatchingsUseCase.matchings()
            
            await MainActor.run {
                self.currentState.matchingProgressInfo = response
                self.currentState.hasMeeting = self.hasMeeting(response)
                self.currentState.shouldWriteReview = self.shouldWriteReview(response)
            }
        } catch {
            
            await MainActor.run {
                self.currentState.matchingProgressInfo = []
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
    
    // TODO: 임시, 모임 중 바텀 싯 표시할 플로팅 뷰 표시 플래그
    func reachedMeetingTime(_ reachedMeeting: MatchingInfo?) async {
        await MainActor.run {
            self.currentState.reachedMeeting = reachedMeeting
        }
    }
    
    func updateMeetingReviewInfo(_ meetingReviewInfo: MeetingReviewViewModel.InitialInfo) async {
        
        await MainActor.run {
            self.currentState.meetingReviewInfo = meetingReviewInfo
        }
    }
}

extension HomeViewModel {
    
    func hasMeeting(_ infos: [MatchingInfo]) -> [MatchingInfo] {
        return infos.filter { $0.matchingStatus == .confirmed }
    }
    
    func shouldWriteReview(_ infos: [MatchingInfo]) -> [MatchingInfo] {
        return infos
            .filter { $0.matchingStatus == .completed }
            .filter { $0.isReviewWritten }
    }
}

// TODO: 매칭된 모임 정보 요약 조회 시, type이 빠져서 임의로 구조체를 만들어 사용.
extension HomeViewModel {
    
    struct MatchingSummariesWithType: Equatable {
        let type: MatchingType
        let info: MatchingSummaryInfo
    }
}
