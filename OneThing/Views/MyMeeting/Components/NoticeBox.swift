//
//  NoticeBox.swift
//  OneThing
//
//  Created by 윤동주 on 7/6/25.
//

import SwiftUI

struct NoticeBox: View {
    var body: some View {
        VStack {
            Text("2025.03.29")
                .otFont(.caption1)
                .fontWeight(.semibold)
            
            HStack(spacing: 6) {
                Text("모임 확정")
                    .otFont(.caption1)
                    .fontWeight(.semibold)
                    .foregroundStyle(.purple400)
                Text("•")
                    .otFont(.caption1)
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray800)
                Text("랜덤모임")
                    .otFont(.caption1)
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray800)
                Spacer()
            }
            
            Text("면접 준비는 어떻게 하고 계시나요? 주제 입력 최대 50자 까지라, 세 줄 까지 나올 수 있을 듯요")
                .otFont(.heading3)
                .fontWeight(.bold)
                .foregroundStyle(.gray800)
                .multilineTextAlignment(.leading)
        }
    }
}

#Preview {
    NoticeBox()
}
