//
//  HomeStore.swift
//  OneThing
//
//  Created by 오현식 on 8/2/25.
//

import SwiftUI

@Observable
class HomeStore: OTStore {
    
    enum Constants {
        /// 피그마 Description, 2시간
        static let timeRangeLimit: TimeInterval = 2 * 60 * 60
        /// 임의의 타이머 interval, 1분
        static let timerInterval: TimeInterval = 60
    }
    
    enum Action: OTAction {
        case landing
        case refresh
        case matchings
        case topBanners
        case updateTopBannerStatus(String)
        case updateInMeetingToday(MatchingInfo)
        case shouldWriteReview(MatchingInfo)
    }
    
    enum Process: OTProcess {
        case unReadNoti(Bool)
        case notices([NoticeInfo])
        case topBanners([NotificationBannerInfo])
        case nickname(String)
        case matchingSummaries([MatchingSummariesWithType])
        case bottomBanners([HomeBannerInfo])
        case matchings([MatchingInfo])
        case updateTopBannerStatus(Bool)
        case reachedMeetingTime(MatchingInfo?)
        case shouldWriteReview(MatchingInfo?)
        
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
        fileprivate(set) var reachedMeeting: MatchingInfo?
        fileprivate(set) var shouldWriteReview: MatchingInfo?
        
        fileprivate(set) var isLoading: Bool
    }
    var state: State
    
    private var dateComparisonTask: Task<MatchingInfo?, Never>?
    private var isWithInTimeRange: Bool = false
    
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
            noticeInfos: [
                // Test: 공지 테스트를 위한 초기 값
                NoticeInfo(noticeType: .notice, content: "원띵 업데이트 공지 어쩌구 저쩌구", link: ""),
                NoticeInfo(noticeType: .article, content: "원띵 업데이트 기사 어쩌구", link: ""),
                NoticeInfo(noticeType: .notice, content: "원띵 업데이트 공지 어쩌구 저쩌구 어쩌구", link: "")
            ],
            matchingSummariesWithType: [
                // Test: 매칭 요약 테스트를 위한 초기 값
                MatchingSummariesWithType(type: .onething, info: .init(matchingId: 11111, daysUntilMeeting: 5, meetingTime: Date(), meetingPlace: "강남")),
                MatchingSummariesWithType(type: .random, info: .init(matchingId: 22222, daysUntilMeeting: 5, meetingTime: Date(), meetingPlace: "강남")),
                MatchingSummariesWithType(type: .instant, info: .init(matchingId: 33333, daysUntilMeeting: 5, meetingTime: Date(), meetingPlace: "강남"))
            ],
            bannerInfos: [],
            matchingProgressInfo: [],
            reachedMeeting: nil,
            shouldWriteReview: nil,
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
        
        Task {
            await self.subscribe()
            await self.writeReview()
        }
    }
    
    func process(_ action: Action) async -> OTProcessResult<Process> {
        switch action {
        case .landing:
            return .concat([
                await self.unReadNoti(),
                // await self.notice(),
                await self.topBanners(),
                await self.bottomBanners(),
                await self.nickname(),
                // await self.matchingSummaries()
            ])
        case .refresh:
            return .concat([
                await self.unReadNoti(),
                await self.notice(),
                await self.topBanners(),
                await self.bottomBanners(),
                await self.matchingSummaries()
            ])
        case .matchings:
            return await self.matchings()
        case .topBanners:
            return await .single(self.topBanners())
        case let .updateTopBannerStatus(id):
            return await self.updateTopBannerStatus(with: id)
        case let .updateInMeetingToday(inMeeting):
            return await self.startTimer(with: inMeeting)
        case let .shouldWriteReview(review):
            return .single(.shouldWriteReview(review))
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
        case let .updateTopBannerStatus(isChangeSuccessForTopBannerStatus):
            newState.isChangeSuccessForTopBannerStatus = isChangeSuccessForTopBannerStatus
        case let .reachedMeetingTime(reachedMeeting):
            newState.reachedMeeting = reachedMeeting
        case let .shouldWriteReview(review):
            newState.shouldWriteReview = review
        case let .updateIsLoading(isLoading):
            newState.isLoading = isLoading
        }
        return newState
    }
}

// TODO: 매칭된 모임 정보 요약 조회 시, type이 빠져서 임의로 구조체를 만들어 사용.
extension HomeStore {
    
    struct MatchingSummariesWithType: Equatable {
        let type: MatchingType
        let info: MatchingSummaryInfo
    }
}


// MARK: Date Timer

private extension HomeStore {
    
    func hasMeeting(_ infos: [MatchingInfo]) -> [MatchingInfo] {
        return infos
            .filter { $0.matchingStatus == .confirmed }
            .filter { $0.meetingTime.isToday }
    }
    
    func shouldWriteReview(_ infos: [MatchingInfo]) -> [MatchingInfo] {
        return infos
            .filter { $0.matchingStatus == .completed }
            .filter { $0.isReviewWritten == false }
    }
    
    func subscribe() async {
        // 저장된 모임 여부 확인
        guard SimpleDefaults.shared.isRecentMatchingsEmpty(with: .inMeeting) == false else {
            LoggingManager.info("Do not have inMeeting today")
            return
        }
        // 저장된 모임 중 오늘 진행될 모임 확인
        let hasMeetings = SimpleDefaults.shared.loadRecentMatchings(with: .inMeeting)
        guard hasMeetings.contains(where: { $0.meetingTime.isToday }),
              let inMeeting = hasMeetings.filter({ $0.meetingTime.isToday }).last
        else {
            // 오늘 진행될 모임이 없다면, 전부 삭제
            SimpleDefaults.shared.removeRecentMatchings(hasMeetings.map { $0.matchingId }, with: .inMeeting)
            LoggingManager.info("Removed all inMeeting")
            return
        }
        
        Task { await self.send(.updateInMeetingToday(inMeeting)) }
    }
    
    func writeReview() async {
        guard SimpleDefaults.shared.isRecentMatchingsEmpty(with: .review) == false else {
            LoggingManager.info("Do not have backlogged reviews")
            return
        }
        
        guard let review = SimpleDefaults.shared.loadRecentMatchings(with: .review).last else {
            LoggingManager.error("Error occur: No backlogged reviews")
            return
        }
        
        Task { await self.send(.shouldWriteReview(review))}
    }
    
    func startTimer(with matching: MatchingInfo) async -> OTProcessResult<Process> {
        // 기존 타이머 관련 변수 초기화
        self.dateComparisonTask?.cancel()
        self.isWithInTimeRange = false
        
        self.dateComparisonTask = Task.detached(priority: .background) { [weak self] in
            // 최초 즉시 비교
            if let hasMeeting = await self?.checkTimeRange(with: matching) {
                return hasMeeting
            }
            // 타이머 루프 (백그라운드 실행)
            while Task.isCancelled == false {
                try? await Task.sleep(for: .seconds(Constants.timerInterval))
                if Task.isCancelled { break }
                if let hasMeeting = await self?.checkTimeRange(with: matching) {
                    return hasMeeting
                }
            }
            
            return nil
        }
        
        return await .single(.reachedMeetingTime(self.dateComparisonTask?.value))
    }
    
    func checkTimeRange(with matching: MatchingInfo) async -> MatchingInfo? {
        // 현재 날짜와 서버에서 받은 날짜를 비교, 0 <= targetDate - currentDate <= 2시간
        let timeDifference = Date().timeIntervalSince(matching.meetingTime)
        let withInRange = timeDifference >= 0 && timeDifference <= Constants.timeRangeLimit
        LoggingManager.info("Get time difference: \(timeDifference), and is in range: \(withInRange)")
        // 상태 변화 검사
        let shouldUpdateRange = self.isWithInTimeRange != withInRange
        // 내부 상태 업데이트
        self.isWithInTimeRange = withInRange
        // 시간 범위 변경 시 호출
        if shouldUpdateRange { return matching }
        // 시간 초과 시 자동 정지
        if withInRange == false {
            self.isWithInTimeRange = false
            self.dateComparisonTask?.cancel()
            self.dateComparisonTask = nil
            
            return nil
        }
        
        return nil
    }
}


// MARK: Request API

private extension HomeStore {
    
    func unReadNoti() async -> Process {
        do {
            let isUnReadNotiEmpty = try await self.getUnReadNotificationUseCase.execute().isEmpty
            return .unReadNoti(isUnReadNotiEmpty)
        } catch {
            return .unReadNoti(true)
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
            
            // 당일 참석할 모임이 있을 경우, UserDefaults에 저장
            let hasMeetins = self.hasMeeting(matchings)
            if hasMeetins.isEmpty == false {
                SimpleDefaults.shared.saveRecentMatchings(hasMeetins, with: .inMeeting)
                Task { await self.subscribe() }
            }
            
            let shouldWriteReview = self.shouldWriteReview(matchings)
            if shouldWriteReview.isEmpty == false {
                SimpleDefaults.shared.saveRecentMatchings(shouldWriteReview, with: .review)
                Task { await self.writeReview() }
            }
            
            return .single(.matchings(matchings))
        } catch {
            return .single(.matchings([]))
        }
    }
    
    // TODO: 임시, 모임 중 바텀 싯 표시할 플로팅 뷰 표시 플래그
    func reachedMeetingTime(_ reachedMeeting: MatchingInfo?) async -> OTProcessResult<Process> {
        return .single(.reachedMeetingTime(reachedMeeting))
    }
}
