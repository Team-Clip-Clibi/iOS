//
//  InMeetingSelectHostView.swift
//  OneThing
//
//  Created by 오현식 on 6/2/25.
//

import SwiftUI

struct InMeetingSelectHostView: View {
    
    enum Constants {
        enum Text {
            static let title = "모임진행"
            static let subTitle = "진행자를 선정해요"
            static let message = "오늘 모임에서는 두 번째로 도착하신 분이, 약 10분 동안 모임을 진행해 주세요"
            
            static let content = "진행자는 카드에 적힌 질문을\n한 장씩 읽으며, 대화를 이끌어 주세요"
            
            static let nextButtonTitle = "다음"
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
                            Image(.selectHost)
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
                    buttonTitle: Constants.Text.nextButtonTitle,
                    action: {
                        self.inMeetingCoordinator.push(to: .home(.inMeeting(.introduce)))
                    },
                    isClickable: true
                )
                .padding([.bottom, .horizontal], 24)
            }
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
    InMeetingSelectHostView(store: .constant(inMeetingStoreForPreview))
}
