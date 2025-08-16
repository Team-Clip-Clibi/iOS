//
//  InMeetingTMIView.swift
//  OneThing
//
//  Created by 오현식 on 6/2/25.
//

import SwiftUI

struct InMeetingTMIView: View {
    
    enum Constants {
        enum Text {
            static let title = "모임진행"
            static let subTitle = "TMI로 조금 더 친해져요"
            static let message = "지금까지 나눈 대화를 참고해, 각 TMI의 주인을 맞춰보세요"
            
            static let nextButtonTitle = "다음"
        }
    }
    
    @Environment(\.inMeetingCoordinator) var inMeetingCoordinator
    
    @Binding var store: InMeetingStore
    
    let cols = [GridItem(), GridItem()]
    
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
                            self.store.state.tmis.indices,
                            id: \.self
                        ) { index in
                            self.setupGridItem(
                                self.store.state.tmis[index],
                                with: index+1
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                }
                
                Spacer()
                
                OTXXLButton(
                    buttonTitle: Constants.Text.nextButtonTitle,
                    action: {
                        self.inMeetingCoordinator.push(to: .home(.inMeeting(.onething)))
                    },
                    isClickable: true
                )
                .padding([.bottom, .horizontal], 24)
            }
        }
    }
}

extension InMeetingTMIView {
    
    func setupGridItem(_ tmi: String, with number: Int) -> some View {
        
        return VStack(alignment: .leading) {
            
            ZStack {
                Color.white100
                    .frame(width: 40, height: 40)
                    .clipShape(.rect(cornerRadius: 8))
                
                Text("\(number)")
                    .otFont(.title1)
                    .foregroundStyle(.gray800)
            }
            
            Spacer()
            
            Text(tmi)
                .otFont(.subtitle1)
                .foregroundStyle(.gray800)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .frame(height: 160)
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
    InMeetingTMIView(store: .constant(inMeetingStoreForPreview))
}
