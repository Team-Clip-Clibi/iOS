//
//  NoticeView.swift
//  OneThing
//
//  Created by 오현식 on 5/9/25.
//

import SwiftUI

struct NoticeView: View {
    
    enum Constants {
        /// 임의의 타이머 interval, 4초
        static let timerInterval: TimeInterval = 4
    }
    
    @Environment(\.openURL) private var openURL
    
    @State private var currentIndex: Int = 0
    
    private(set) var notices: [NoticeInfo]
    
    var body: some View {
        
        if self.notices.isEmpty == false {
            
            ZStack {
                
                Color.gray200
                
                if self.notices.count > 1 {
                    
                    let notice = self.notices[self.currentIndex]
                    self.setupNotice(notice)
                        .id(self.currentIndex)
                        .intervalWithAnimation(
                            hasTimerStopped: .constant(false),
                            self.notices.count,
                            duration: Constants.timerInterval,
                            transition: .opacity.combined(with: .offset(y: 5)),
                            onIndexChanged: { new in
                                withAnimation(.easeInOut(duration: 0.4)) {
                                    self.currentIndex = new
                                }
                            }
                        )
                } else {
                    
                    if let notice = self.notices.last {
                        self.setupNotice(notice)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 34)
            .clipped()
        } else {
            EmptyView()
        }
    }
}

private extension NoticeView {
    
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
