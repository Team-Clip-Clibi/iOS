//
//  Animation+Modifier.swift
//  OneThing
//
//  Created by 오현식 on 8/23/25.
//

import SwiftUI

struct IntervalWithAnimationModifier: ViewModifier {
    
    @State private var timer: Timer?
    @State private var currentIndex: Int = 0
    
    @Binding var hasTimerStopped: Bool
    
    let totalCount: Int
    let timeInterval: TimeInterval
    let transition: AnyTransition?
    let onIndexChanged: (Int) -> Void
    
    
    init(
        hasTimerStopped: Binding<Bool>,
        _ totalCount: Int,
        duration timeInterval: TimeInterval,
        transition: AnyTransition?,
        onIndexChanged: @escaping (Int) -> Void
    ) {
        self._hasTimerStopped = hasTimerStopped
        self.totalCount = totalCount
        self.timeInterval = timeInterval
        self.transition = transition
        self.onIndexChanged = onIndexChanged
    }
    
    func body(content: Content) -> some View {
        
        if let transition = self.transition {
            content
                .transition(transition)
                .onAppear {
                    if self.hasTimerStopped == false {
                        self.startTimer()
                    }
                }
                .onDisappear { self.stopTimer() }
                .onChange(of: self.hasTimerStopped) { old, new in
                    guard old != new else { return }
                    
                    if new == false { self.startTimer() }
                    else { self.stopTimer() }
                }
        } else {
            content
                .onAppear {
                    if self.hasTimerStopped == false {
                        self.startTimer()
                    }
                }
                .onDisappear { self.stopTimer() }
                .onChange(of: self.hasTimerStopped) { old, new in
                    guard old != new else { return }
                    
                    if new == false { self.startTimer() }
                    else { self.stopTimer() }
                }
        }
    }
}

private extension IntervalWithAnimationModifier {
    
    func startTimer() {
        // 이미 타이머가 실행 중인 경우 중복 생성 방지
        guard self.timer == nil else { return }
        
        // 1분 간격으로 타이머 설정
        self.timer = Timer.scheduledTimer(
            withTimeInterval: self.timeInterval,
            repeats: true
        ) { _ in
            let newIndex = (self.currentIndex + 1) % self.totalCount
            self.currentIndex = newIndex
            self.onIndexChanged(newIndex)
        }
    }
    
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
}

extension View {
    
    func intervalWithAnimation(
        hasTimerStopped: Binding<Bool>,
        _ totalCount: Int,
        duration timeInterval: TimeInterval,
        transition: AnyTransition? = nil,
        onIndexChanged: @escaping (Int) -> Void
    ) -> some View {
        return self.modifier(
            IntervalWithAnimationModifier(
                hasTimerStopped: hasTimerStopped,
                totalCount,
                duration: timeInterval,
                transition: transition,
                onIndexChanged: onIndexChanged
            )
        )
    }
}
