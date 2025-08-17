//
//  InMeetingContentView.swift
//  OneThing
//
//  Created by 오현식 on 6/5/25.
//

import SwiftUI

struct InMeetingContentView: View {
    
    enum Constants {
        enum Text {
            static let title = "모임진행"
            static let subTitle = "자유롭게 대화를 나눠요"
            static let message = "준비된 원띵 질문은 여기까지! 원띵 질문 외에 다양한 주제로 대화를 이어가 보세요"
            
            static let nextButtonTitle = "다음"
        }
    }
    
    @Environment(\.homeCoordinator) var homeCoordinator
    
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
                
                VStack(spacing: 20) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        Spacer().frame(height: 32)
                        
                        LazyHStack {
                            ForEach(
                                0..<InMeetingContentInfo.mock.count,
                                id: \.self
                            ) { page in
                                self.setupGridItem(InMeetingContentInfo.mock[page])
                                    .tag(page)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollPosition(id: Binding($currentPage))
                    .safeAreaPadding(.horizontal, 24)
                    
                    Text("\(InMeetingContentInfo.mock[self.currentPage].number)/\(InMeetingContentInfo.mock.count)")
                        .otFont(.caption1)
                        .foregroundStyle(.gray500)
                }
                /// top padding + card height + bottom page view
                .frame(height: 458)
                
                Spacer()
                
                OTXXLButton(
                    buttonTitle: Constants.Text.nextButtonTitle,
                    action: {
                        self.homeCoordinator.push(to: .home(.inMeeting(.complete)))
                    },
                    isClickable: true
                )
                .padding(.bottom, 12)
                .padding(.horizontal, 24)
            }
        }
    }
}

extension InMeetingContentView {
    
    func setupGridItem(_ contentInfo: InMeetingContentInfo) -> some View {
        
        return VStack {
            
            ZStack {
                Color.purple400
                    .frame(width: 44, height: 44)
                    .clipShape(.rect(cornerRadius: 10))
                
                Text("\(contentInfo.number)")
                    .otFont(.heading3)
                    .foregroundStyle(.white100)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer().frame(height: 28)
            
            Text(contentInfo.message)
                .otFont(.heading3)
                .foregroundStyle(.gray800)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .padding([.top, .horizontal], 28)
        .padding(.bottom, 20)
        .frame(width: 280, height: 400)
        .background(.purple100)
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
    InMeetingContentView(store: .constant(inMeetingStoreForPreview))
}
