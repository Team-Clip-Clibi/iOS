//
//  InMeetingOnethingView.swift
//  OneThing
//
//  Created by 오현식 on 6/3/25.
//

import SwiftUI

struct InMeetingOnethingView: View {
    
    enum Constants {
        enum Text {
            static let title = "모임진행"
            static let subTitle = "원띵을 소개해요"
            static let message = "카드를 넘겨 멤버들의 원띵을 확인하며 이야기를 나눠 보세요"
            
            static let nextButtonTitle = "다음"
        }
    }
    
    @Environment(\.inMeetingCoordinator) var inMeetingCoordinator
    
    @Binding var store: InMeetingStore
    
    @State private var currentPage: Int = 0
    
    var body: some View {
        
        OTBaseView(String(describing: Self.self), isEndEditingWhenOnDisappear: false) {
            
            VStack {
                
                InMeetingGuideMessageView(
                    title: Constants.Text.title,
                    subTitle: Constants.Text.subTitle,
                    message: Constants.Text.message
                )
                
                let onethings = self.store.state.onethings
                if onethings.isEmpty == false {
                    Spacer().frame(height: 32)
                    
                    VStack(spacing: 20) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                ForEach(
                                    0..<onethings.count,
                                    id: \.self
                                ) { page in
                                    self.setupGridItem(
                                        onethings[page],
                                        nickname: self.store.state.nicknames[page]
                                    )
                                        .tag(page)
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .contentMargins(.horizontal, 24, for: .scrollContent)
                        .scrollTargetBehavior(.viewAligned)
                        .scrollPosition(id: Binding($currentPage))
                        
                        let number = onethings[self.currentPage].number
                        Text("\(number)/\(onethings.count)")
                            .otFont(.caption1)
                            .foregroundStyle(.gray500)
                    }
                    .frame(height: 438)
                }
                
                
                Spacer()
                
                OTXXLButton(
                    buttonTitle: Constants.Text.nextButtonTitle,
                    action: {
                        self.inMeetingCoordinator.push(to: .home(.inMeeting(.content)))
                    },
                    isClickable: (self.currentPage+1) == self.store.state.onethingCount
                )
                .padding([.bottom, .horizontal], 24)
            }
        }
    }
}

extension InMeetingOnethingView {
    
    func setupGridItem(_ onething: OnethingInfo, nickname: String) -> some View {
        
        return VStack {
            
            ZStack {
                Color.white100
                    .frame(width: 44, height: 44)
                    .clipShape(.rect(cornerRadius: 10))
                
                Text("\(onething.number)")
                    .otFont(.heading3)
                    .foregroundStyle(.gray800)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer().frame(height: 28)
            
            Text(onething.category)
                .otFont(.title1)
                .foregroundStyle(.gray800)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer().frame(height: 6)
            
            Text(onething.message)
                .otFont(.heading3)
                .foregroundStyle(.gray800)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            Text("\(nickname)의 원띵")
                .otFont(.subtitle2)
                .foregroundStyle(.gray800)
        }
        .padding([.top, .horizontal], 28)
        .padding(.bottom, 20)
        .frame(width: 280, height: 400)
        .background(onething.backgroundColor)
        .clipShape(.rect(cornerRadius: 20))
    }
}

#Preview {
    let inMeetingStoreForPreview = InMeetingStore(
        getMatchingsUseCase: GetMatchingsUseCase(),
        updateMatchingsStatusUseCase: UpdateMatchingsStatusUseCase(),
        matchingId: "",
        matchingType: .onething
    )
    InMeetingOnethingView(store: .constant(inMeetingStoreForPreview))
}
