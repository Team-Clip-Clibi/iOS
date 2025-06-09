//
//  DateComparisonManager.swift
//  OneThing
//
//  Created by 오현식 on 6/9/25.
//

import SwiftUI

@MainActor
class DateComparisonManager: ObservableObject {
    
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
    
    private var timer: Timer?
    
    // 타이머 경과를 외부에서 받을 수 있도록 하는 클로져
    private var onTimeRangeChanged: TimeRangeCallback?
    private var onTimeExceeded: TimeExceededCallback?
    
    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    // 서버에서 받은 Date를 설정하고 모니터링 시작
    func startMonitoring(
        with targetDate: Date,
        onTimeRangeChanged: TimeRangeCallback?,
        onTimeExceeded: TimeExceededCallback?
    ) {
        self.isActive = true
        
        self.onTimeRangeChanged = onTimeRangeChanged
        self.onTimeExceeded = onTimeExceeded
        
        self.startTimer(with: targetDate)
    }
    
    // 모니터링 중지 및 상태 초기화
    func stopMonitoring() {
        self.stopTimer()
        
        self.isWithinTimeRange = false
        self.isActive = false
        
        self.onTimeRangeChanged = nil
        self.onTimeExceeded = nil
    }
}

extension DateComparisonManager {
    
    private func startTimer(with targetDate: Date) {
        self.stopTimer()
        self.checkTimeRange(with: targetDate)
        
        self.timer = Timer.scheduledTimer(
            withTimeInterval: Constants.timerInterval,
            repeats: true
        ) { [weak self] _ in
            // 비동기 메인 스레드에서 동작
            Task { @MainActor [weak self] in self?.checkTimeRange(with: targetDate) }
        }
    }
    
    private func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    private func checkTimeRange(with targetDate: Date) {
        guard self.isActive else {
            self.isWithinTimeRange = false
            return
        }
        
        // 현재 날짜와 서버에서 받은 날짜를 비교, 0 <= targetDate - currentDate <= 2시간
        let currentDate = Date()
        let timeDifference = currentDate.timeIntervalSince(targetDate)
        let withinRange = timeDifference >= 0 && timeDifference <= Constants.timeRangeLimit
        
        if self.isWithinTimeRange != withinRange {
            self.onTimeRangeChanged?(withinRange)
        }
        
        self.isWithinTimeRange = withinRange
        
        // 시간 초과 시 자동 정지
        if withinRange == false {
            self.onTimeExceeded?()
            self.stopMonitoring()
        }
    }
}
