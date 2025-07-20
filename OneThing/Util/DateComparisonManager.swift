//
//  DateComparisonManager.swift
//  OneThing
//
//  Created by 오현식 on 6/9/25.
//

import SwiftUI

final class DateComparisonManager {
    
    typealias TimeRangeCallback = (Bool) -> Void
    typealias TimeExceededCallback = () -> Void
    
    enum Constants {
        /// 피그마 Description, 2시간
        static let timeRangeLimit: TimeInterval = 2 * 60 * 60
        /// 임의의 타이머 interval, 1분
        static let timerInterval: TimeInterval = 60
    }
    
    private var isWithinTimeRange: Bool = false
    private var isActive: Bool = false
    
    private var targetDate: Date?
    private var backgroundTimer: Task<Void, Never>?
    
    // 타이머 경과를 외부에서 받을 수 있도록 하는 클로져
    private var onTimeRangeChanged: TimeRangeCallback?
    private var onTimeExceeded: TimeExceededCallback?
    
    deinit {
        self.stopMonitoring()
    }
    
    // 서버에서 받은 Date를 설정하고 모니터링 시작
    func startMonitoring(
        with targetDate: Date,
        onTimeRangeChanged: TimeRangeCallback?,
        onTimeExceeded: TimeExceededCallback?
    ) {
        self.isActive = true
        
        self.targetDate = targetDate
        
        self.onTimeRangeChanged = onTimeRangeChanged
        self.onTimeExceeded = onTimeExceeded
        
        self.startTimer(with: targetDate)
    }
    
    // 모니터링 중지 및 상태 초기화
    func stopMonitoring() {
        self.isWithinTimeRange = false
        self.isActive = false
        
        self.targetDate = nil
        self.backgroundTimer?.cancel()
        self.backgroundTimer = nil
        
        self.onTimeRangeChanged = nil
        self.onTimeExceeded = nil
    }
}

private extension DateComparisonManager {
    
    func startTimer(with targetDate: Date) {
        self.backgroundTimer?.cancel()
        
        self.backgroundTimer = Task.detached(priority: .background) { [weak self] in
            // 최초 비교 즉시 실행
            await self?.checkTimeRange()
            // 타이머 루프 (백그라운드에서 실행)
            while Task.isCancelled == false {
                try? await Task.sleep(for: .seconds(Constants.timerInterval))
                if Task.isCancelled { break }
                await self?.checkTimeRange()
            }
        }
    }
    
    func checkTimeRange() async {
        // 목표 날자가 존재하고
        guard let targetDate = self.targetDate,
              self.isActive
        else { return }
        
        // 현재 날짜와 서버에서 받은 날짜를 비교, 0 <= targetDate - currentDate <= 2시간
        let currentDate = Date()
        let timeDifference = targetDate.timeIntervalSince(currentDate)
        let withinRange = timeDifference >= 0 && timeDifference <= Constants.timeRangeLimit
        let remainingTime = max(0, timeDifference)
        
        // 상태 변화 검사
        let shouldUpdateRange = self.isWithinTimeRange != withinRange
        // 내부 상태 업데이트
        self.isWithinTimeRange = withinRange
        
        // 메인 스레드에서 클로저 호출
        await MainActor.run {
            // 시간 범위 변경 시 호출
            if shouldUpdateRange { self.onTimeRangeChanged?(withinRange) }
        }
        
        // 시간 초과 시 자동 정지
        if withinRange == false {
            await MainActor.run {
                self.onTimeExceeded?()
            }
            self.stopMonitoring()
        }
    }
}
