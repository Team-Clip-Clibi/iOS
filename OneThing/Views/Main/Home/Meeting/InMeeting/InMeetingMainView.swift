//
//  InMeetingMainView.swift
//  OneThing
//
//  Created by 오현식 on 6/2/25.
//

import SwiftUI

struct InMeetingMainView: View {
    
    enum Constants {
        enum Text {
            static let title = "모임시작"
            static let subTitle = "인사는 나누셨나요?"
            static let message = """
                아직 도착하지 않은 멤버가 있다면, 앱 내 알림내역에서 도착 예정 시간을 확인 후 메뉴를 먼저 주문해요
            """
            static let content = "원하는 메뉴를 주문하고,\n닉네임 또는 실명으로 소개해 주세요"
            
            static let startMeetingButtonTitle = "모임 시작하기"
        }
    }
    
    @Environment(\.inMeetingCoordinator) var inMeetingCoordinator
    
    @Binding var store: InMeetingStore
    
    var body: some View {
        
        OTBaseView(String(describing: Self.self), isEndEditingWhenOnDisappear: false) {
            
            VStack {
                InMeetingGuideMessageView(
                    title: Constants.Text.title,
                    subTitle: Constants.Text.subTitle,
                    message: Constants.Text.message
                )
                
                ScrollView(.vertical, showsIndicators: false) {
                    Spacer().frame(height: 32)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.purple100)
                        
                        VStack(spacing: 32) {
                            Image(.inMeetingMain)
                                .resizable()
                                .frame(width: 267, height: 223)
                            
                            Text(Constants.Text.content)
                                .otFont(.title1)
                                .foregroundStyle(.gray800)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal, 24)
                    .frame(maxWidth: .infinity)
                    .frame(height: 460)
                }
                
                Spacer()
                
                OTXXLButton(
                    buttonTitle: Constants.Text.startMeetingButtonTitle,
                    action: { self.inMeetingCoordinator.push(to: .home(.inMeeting(.selectHost))) },
                    isClickable: true
                )
                .padding([.bottom, .horizontal], 24)
            }
        }
        .taskForOnce {
            await self.store.send(.landing)
        }
    }
}

#Preview {
    let inMeetingStoreForPreview = InMeetingStore(
        getMatchingsUseCase: GetMatchingsUseCase(),
        updateMatchingsStatusUseCase: UpdateMatchingsStatusUseCase(),
        matchingId: "",
        matchingType: .onething
    )
    InMeetingMainView(store: .constant(inMeetingStoreForPreview))
}
