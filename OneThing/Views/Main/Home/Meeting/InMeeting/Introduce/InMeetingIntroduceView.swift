//
//  InMeetingIntroduceView.swift
//  OneThing
//
//  Created by 오현식 on 6/2/25.
//

import SwiftUI

struct InMeetingIntroduceView: View {
    
    enum Constants {
        enum Text {
            static let title = "모임진행"
            static let subTitle = "닉네임으로 나를 소개해요"
            static let message = "아래 순서대로 나이, 취미, 관심사 등을 소개해 주세요 공개하고 싶지 않은 정보는 생략해도 괜찮아요"
            
            static let nextButtonTitle = "다음"
        }
    }
    
    @Environment(\.homeCoordinator) var homeCoordinator
    
    @Binding var store: InMeetingStore
    
    let cols = [GridItem()]
    
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
                    
                    LazyVGrid(columns: self.cols) {
                        ForEach(
                            self.store.state.nicknames.indices,
                            id: \.self
                        ) { index in
                            self.setupGridItem(
                                self.store.state.nicknames[index],
                                with: index+1
                            )
                        }
                        .padding(.horizontal, 24)
                    }
                }
                
                Spacer()
                
                OTXXLButton(
                    buttonTitle: Constants.Text.nextButtonTitle,
                    action: {
                        self.homeCoordinator.push(to: .home(.inMeeting(.tmi)))
                    },
                    isClickable: true
                )
                .padding(.bottom, 12)
                .padding(.horizontal, 24)
            }
        }
    }
}

extension InMeetingIntroduceView {
    
    func setupGridItem(_ nickname: String, with number: Int) -> some View {
        
        return HStack(spacing: 14) {
            
            ZStack {
                Color.white100
                    .frame(width: 40, height: 40)
                    .clipShape(.rect(cornerRadius: 8))
                
                Text("\(number)")
                    .otFont(.title1)
                    .foregroundStyle(.gray800)
            }
            
            Text(nickname)
                .otFont(.title1)
                .foregroundStyle(.gray800)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .frame(height: 68)
        .background(.gray100)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray200, lineWidth: 1)
        )
        .clipShape(.rect(cornerRadius: 16))
    }
}

#Preview {
    let inMeetingStoreForPreview = InMeetingStore(
        getMatchingsUseCase: GetMatchingsUseCase(),
        updateMatchingsStatusUseCase: UpdateMatchingsStatusUseCase(),
        matchingId: "",
        matchingType: .onething
    )
    InMeetingIntroduceView(store: .constant(inMeetingStoreForPreview))
}
