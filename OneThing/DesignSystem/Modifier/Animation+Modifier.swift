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
    
    let totalCount: Int
    let timeInterval: TimeInterval
    let transition: AnyTransition?
    let onIndexChanged: (Int) -> Void
    
    
    init(
        _ totalCount: Int,
        duration timeInterval: TimeInterval,
        transition: AnyTransition?,
        onIndexChanged: @escaping (Int) -> Void
    ) {
        self.totalCount = totalCount
        self.timeInterval = timeInterval
        self.transition = transition
        self.onIndexChanged = onIndexChanged
    }
    
    func body(content: Content) -> some View {
        
        Group {
            if let transition = self.transition {
                content.transition(transition)
            } else {
                content
            }
        }
        .onAppear { self.startTimer() }
        .onDisappear { self.stopTimer() }
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
        _ totalCount: Int,
        duration timeInterval: TimeInterval,
        transition: AnyTransition? = nil,
        onIndexChanged: @escaping (Int) -> Void
    ) -> some View {
        return self.modifier(
            IntervalWithAnimationModifier(
                totalCount,
                duration: timeInterval,
                transition: transition,
                onIndexChanged: onIndexChanged
            )
        )
    }
}
