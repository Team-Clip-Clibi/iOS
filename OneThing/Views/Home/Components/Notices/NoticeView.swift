//
//  NoticeView.swift
//  OneThing
//
//  Created by 오현식 on 5/9/25.
//

import SwiftUI

struct NoticeView: View {
    
    @Environment(\.openURL) private var openURL
    
    private(set) var notices: [NoticeInfo]
    
    var body: some View {
        if self.notices.isEmpty == false, let notice = self.notices.last {
            
            HStack(alignment: .center) {
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
        } else {
            EmptyView()
        }
    }
}

#Preview {
    NoticeView(
        notices: [NoticeInfo(noticeType: .notice, content: "원띵 업데이트 공지 어쩌구 저쩌구", link: "")]
    )
}
