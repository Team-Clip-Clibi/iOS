//
//  NoticeView.swift
//  OneThing
//
//  Created by 오현식 on 5/9/25.
//

import SwiftUI

struct NoticeView: View {
    
    enum Constants {
        /// 임의의 타이머 interval, 1분
        static let timerInterval: TimeInterval = 3
    }
    
    @Environment(\.openURL) private var openURL
    
    @State private var currentIndex: Int = 0
    @State private var timer: Timer?
    
    private(set) var notices: [NoticeInfo]
    
    var body: some View {
        if self.notices.count > 1 {
            
            let notice = self.notices[self.currentIndex]
            self.setupNotice(notice)
                .id(notice.content)
                .transition(.scale.animation(.easeInOut(duration: 0.8)))
                .onAppear { self.startTimer() }
                .onDisappear { self.stopTimer() }
        } else {
            if let notice = self.notices.last {
                self.setupNotice(notice)
            }
        }
    }
}

private extension NoticeView {
    
    private func startTimer() {
        // 이미 타이머가 실행 중인 경우 중복 생성 방지
        guard self.timer == nil else { return }
        
        // 1분 간격으로 타이머 설정
        self.timer = Timer.scheduledTimer(
            withTimeInterval: Constants.timerInterval,
            repeats: true
        ) { _ in
            self.currentIndex = (self.currentIndex + 1) % self.notices.count
        }
    }
    
    private func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func setupNotice(_ notice: NoticeInfo) -> some View {
        
        return HStack(alignment: .center) {
            Text(notice.noticeType.description)
                .otFont(.caption1)
                .fontWeight(.bold)
                .foregroundStyle(.red100)
            
            Spacer().frame(width: 12)
            
            Text(notice.content)
                .otFont(.caption1)
                .foregroundStyle(.gray800)
            
            Spacer(minLength: 16)
        }
        .padding(.leading, 17)
        .padding(.trailing, 9)
        .frame(maxWidth: .infinity)
        .frame(height: 34)
        .background(Color.gray200)
        .onTapGesture {
            guard let url = URL(string: notice.link) else { return }
            self.openURL(url)
        }
    }
}

#Preview {
    NoticeView(
        notices: [
            NoticeInfo(noticeType: .notice, content: "원띵 업데이트 공지 어쩌구 저쩌구 111", link: "")
        ]
    )
}
