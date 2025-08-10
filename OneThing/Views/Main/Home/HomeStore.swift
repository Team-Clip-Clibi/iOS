//
//  HomeStore.swift
//  OneThing
//
//  Created by 오현식 on 8/2/25.
//

import SwiftUI

@Observable
class HomeStore: OTStore {
    
    enum Action: OTAction {
        case landing
        case refresh
        case matchings
        case topBanners
        case updateTopBannerStatus(String)
        case reachedMeetingTime(MatchingInfo?)
        case updateMeetingReviewInfo(MeetingReviewViewModel.InitialInfo)
    }
    
    enum Process: OTProcess {
        case unReadNoti(Bool)
        case notices([NoticeInfo])
        case topBanners([NotificationBannerInfo])
        case nickname(String)
        case matchingSummaries([MatchingSummariesWithType])
        case bottomBanners([HomeBannerInfo])
        case matchings([MatchingInfo])
        case updateHasMeeting([MatchingInfo])
        case updateShouldWriteReview([MatchingInfo])
        case updateTopBannerStatus(Bool)
        case reachedMeetingTime(MatchingInfo?)
        case updateMeetingReviewInfo(MeetingReviewViewModel.InitialInfo)
        
        case updateIsLoading(Bool)
    }
    
    struct State: OTState {
        fileprivate(set) var nickname: String
        fileprivate(set) var isUnReadNotiEmpty: Bool
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
    var state: State
    
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
        getProfileUseCase: GetProfileInfoUseCase,
        getUnReadNotificationUseCase: GetUnReadNotificationUseCase,
        getNotificationBannerUseCase: GetNotificationBannerUseCase,
        updateNotificationBannerUseCase: UpdateNotificationBannerUseCase,
        noticeUseCase: GetNoticeUseCase,
        getMatchingStatusUseCase: GetMatchingStatusUseCase,
        getMatchingsUseCase: GetMatchingsUseCase,
        bannerUseCase: GetBannerUseCase
    ) {
        
        self.state = State(
            nickname: "",
            isUnReadNotiEmpty: true,
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
    
    func process(_ action: Action) async -> OTProcessResult<Process> {
        switch action {
        case .landing:
            return .concat([
                await self.unReadNoti(),
                await self.notice(),
                await self.topBanners(),
                await self.bottomBanners(),
                await self.nickname(),
                await self.matchingSummaries()
            ])
        case .refresh:
            return .concat([
                await self.unReadNoti(),
                await self.notice(),
                await self.topBanners(),
                await self.matchingSummaries()
            ])
        case .matchings:
            return await self.matchings()
        case .topBanners:
            return await .single(self.topBanners())
        case let .updateTopBannerStatus(id):
            return await self.updateTopBannerStatus(with: id)
        case let .reachedMeetingTime(reachedMeeting):
            return await self.reachedMeetingTime(reachedMeeting)
        case let .updateMeetingReviewInfo(meetingReviewInfo):
            return await self.updateMeetingReviewInfo(meetingReviewInfo)
        }
    }
    
    func reduce(state: State, process: Process) -> State {
        var newState = state
        switch process {
        case let .unReadNoti(isUnReadNotiEmpty):
            newState.isUnReadNotiEmpty = isUnReadNotiEmpty
        case let .notices(noticeInfos):
            newState.noticeInfos = noticeInfos
        case let .topBanners(topBannerInfos):
            newState.topBannerInfos = topBannerInfos
            newState.isChangeSuccessForTopBannerStatus = false
        case let .nickname(nickname):
            newState.nickname = nickname
        case let .matchingSummaries(matchingSummariesWithType):
            newState.matchingSummariesWithType = matchingSummariesWithType
        case let .bottomBanners(bannerInfos):
            newState.bannerInfos = bannerInfos
        case let .matchings(matchingProgressInfo):
            newState.matchingProgressInfo = matchingProgressInfo
        case let .updateHasMeeting(hasMeeting):
            newState.hasMeeting = hasMeeting
        case let .updateShouldWriteReview(shouldWriteReview):
            newState.shouldWriteReview = shouldWriteReview
        case let .updateTopBannerStatus(isChangeSuccessForTopBannerStatus):
            newState.isChangeSuccessForTopBannerStatus = isChangeSuccessForTopBannerStatus
        case let .reachedMeetingTime(reachedMeeting):
            newState.reachedMeeting = reachedMeeting
        case let .updateMeetingReviewInfo(meetingReviewInfo):
            newState.meetingReviewInfo = meetingReviewInfo
        case let .updateIsLoading(isLoading):
            newState.isLoading = isLoading
        }
        return newState
    }
}

extension HomeStore {
    
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
extension HomeStore {
    
    struct MatchingSummariesWithType: Equatable {
        let type: MatchingType
        let info: MatchingSummaryInfo
    }
}

private extension HomeStore {
    
    func unReadNoti() async -> Process {
        do {
            let isUnReadNotiEmpty = try await self.getUnReadNotificationUseCase.execute().isEmpty
            return .unReadNoti(isUnReadNotiEmpty)
        } catch {
            return .unReadNoti(false)
        }
    }
    
    func notice() async -> Process {
        do {
            let notices = try await self.noticeUseCase.execute()
            return .notices(notices)
        } catch {
            return .notices([])
        }
    }
    
    func topBanners() async -> Process {
        do {
            let topBanners = try await self.getNotificationBannerUseCase.execute()
            return .topBanners(topBanners)
        } catch {
            return .topBanners([])
        }
    }
    
    func updateTopBannerStatus(with id: String) async -> OTProcessResult<Process> {
        do {
            let isSuccess = try await self.updateNotificationBannerUseCase.execute(with: id)
            return .single(.updateTopBannerStatus(isSuccess))
        } catch {
            return .single(.updateTopBannerStatus(false))
        }
    }
    
    func nickname() async -> Process {
        do {
            let nickname = try await self.getProfileUseCase.execute().nickname
            return .nickname(nickname)
        } catch {
            return .nickname("")
        }
    }
    
    func matchingSummaries() async -> Process {
        do {
            let matchingSummariesInfo = try await self.getMatchingStatusUseCase.matchingsSummaries()
            var matchingSummariesWithType: [MatchingSummariesWithType] {
                let fromOnethings = matchingSummariesInfo.onethings.map {
                    MatchingSummariesWithType(type: .onething, info: $0)
                }
                let fromRandoms = matchingSummariesInfo.randoms.map {
                    MatchingSummariesWithType(type: .random, info: $0)
                }
                
                return fromOnethings + fromRandoms
            }
            return .matchingSummaries(matchingSummariesWithType)
        } catch {
            return .matchingSummaries([])
        }
    }
    
    func bottomBanners() async -> Process {
        do {
            let bottomBanners: [HomeBannerInfo] = try await self.bannerUseCase.execute(with: .home)
            return .bottomBanners(bottomBanners)
        } catch {
            return .bottomBanners([])
        }
    }
    
    func matchings() async -> OTProcessResult<Process> {
        do {
            let matchings = try await self.getMatchingsUseCase.matchings()
            return .concat([
                .matchings(matchings),
                .updateHasMeeting(self.hasMeeting(matchings)),
                .updateShouldWriteReview(self.shouldWriteReview(matchings))
            ])
        } catch {
            return .single(.matchings([]))
        }
    }
    
    // TODO: 임시, 모임 중 바텀 싯 표시할 플로팅 뷰 표시 플래그
    func reachedMeetingTime(_ reachedMeeting: MatchingInfo?) async -> OTProcessResult<Process> {
        return .single(.reachedMeetingTime(reachedMeeting))
    }
    
    func updateMeetingReviewInfo(
        _ meetingReviewInfo: MeetingReviewViewModel.InitialInfo
    ) async -> OTProcessResult<Process> {
        return .single(.updateMeetingReviewInfo(meetingReviewInfo))
    }
}
