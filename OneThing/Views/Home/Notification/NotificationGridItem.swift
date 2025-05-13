//
//  NotificationGridItem.swift
//  OneThing
//
//  Created by 오현식 on 5/10/25.
//

import SwiftUI

struct NotificationGridItem: View {
    
    private(set) var notification: NotificationInfo
    private(set) var isNew: Bool
    
    private var tintColor: Color {
        switch self.notification.notificationType {
        case .meeting: return .purple400
        case .event: return .yellow100
        case .notice: return .red100
        }
    }
    
    private var imageResource: ImageResource {
        switch self.notification.notificationType {
        case .meeting: return .teamFill
        case .event: return .giftFill
        case .notice: return .notiFill
        }
    }
    
    private var dateString: String {
        let createdAt = self.notification.createdAt
        return self.isNew ? createdAt.infoReadableTimeTakenFromThis(to: Date()): createdAt.readNotiFormatted
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Image(self.imageResource)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(self.tintColor)
                
                Spacer().frame(width: 8)
                
                Text(self.notification.notificationType.title)
                    .otFont(.body1)
                    .foregroundStyle(.gray500)
                
                Spacer(minLength: 8)
                
                Text(self.dateString)
                    .otFont(.body1)
                    .foregroundStyle(.gray500)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 24)
            
            Spacer().frame(height: 4)
            
            Text(self.notification.content)
                .otFont(.subtitle2)
                .multilineTextAlignment(.leading)
                .foregroundStyle(.gray700)
                .padding(.leading, 32)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .overlay(
            Rectangle()
                .frame(width: nil, height: 1, alignment: .bottom)
                .foregroundStyle(.gray200),
            alignment: .bottom
        )
    }
}

#Preview {
    NotificationGridItem(
        notification: NotificationInfo(
            id: "1234",
            notificationType: .meeting,
            content: "신청한 모임이 매칭되었어요! 모임 참여를 확정해주세요",
            createdAt: Date()
        ),
        isNew: true
    )
    NotificationGridItem(
        notification: NotificationInfo(
            id: "12345",
            notificationType: .event,
            content: "오늘 이태원에서 모임이 예정되어있어요. 이따가 만나요!",
            createdAt: Date()
        ),
        isNew: true
    )
    NotificationGridItem(
        notification: NotificationInfo(
            id: "123456",
            notificationType: .notice,
            content: "계정 보호를 위해 꼭 확인해주세요",
            createdAt: Date()
        ),
        isNew: false
    )
}
