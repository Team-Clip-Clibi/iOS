//
//  InMeetingOneThingView.swift
//  OneThing
//
//  Created by 오현식 on 6/3/25.
//

import SwiftUI

struct InMeetingOneThingView: View {
    
    enum Constants {
        enum Text {
            static let title = "모임진행"
            static let subTitle = "원띵을 소개해요"
            static let message = "카드를 넘겨 멤버들의 원띵을 확인하며 이야기를 나눠 보세요"
            
            static let nextButtonTitle = "다음"
        }
    }
    
    @Binding var inMeetingPathManager: OTInMeetingPathManager
    
    @State private var currentPage: Int = 0
    
    var body: some View {
        
        VStack {
            
            InMeetingGuideMessageView(
                title: Constants.Text.title,
                subTitle: Constants.Text.subTitle,
                message: Constants.Text.message
            )
            
            Spacer().frame(height: 32)
            
            if let onethings = self.viewModel.currentState.onethings, onethings.isEmpty == false {
                
                VStack(spacing: 20) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(
                                0..<onethings.count,
                                id: \.self
                            ) { page in
                                self.setupGridItem(
                                    onethings[page],
                                    nickname: self.viewModel.currentState.nicknames[page]
                                )
                                    .tag(page)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollPosition(id: Binding($currentPage))
                    .safeAreaPadding(.horizontal, 24)
                    
                    let number = onethings[self.currentPage].number
                    Text("\(number)/\(self.viewModel.currentState.onethingCount)")
                        .otFont(.caption1)
                        .foregroundStyle(.gray500)
                }
                .frame(height: 438)
            }
            
            Spacer()
            
            OTXXLButton(
                buttonTitle: Constants.Text.nextButtonTitle,
                action: { self.inMeetingPathManager.push(path: .content) },
                isClickable: (self.currentPage+1) == OneThingInfo.mock.count
            )
            .padding(.bottom, 12)
            .padding(.horizontal, 24)
        }
        .navigationBarBackButtonHidden()
    }
}

extension InMeetingOneThingView {
    
    func setupGridItem(_ oneThingInfo: OneThingInfo) -> some View {
        
        return VStack {
            
            ZStack {
                Color.white100
                    .frame(width: 44, height: 44)
                    .clipShape(.rect(cornerRadius: 10))
                
                Text("\(oneThingInfo.number)")
                    .otFont(.heading3)
                    .foregroundStyle(.gray800)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer().frame(height: 28)
            
            Text(oneThingInfo.category)
                .otFont(.title1)
                .foregroundStyle(.gray800)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer().frame(height: 6)
            
            Text(oneThingInfo.message)
                .otFont(.heading3)
                .foregroundStyle(.gray800)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            Text("민만민님의 원띵")
                .otFont(.subtitle2)
                .foregroundStyle(.gray800)
        }
        .padding([.top, .horizontal], 28)
        .padding(.bottom, 20)
        .frame(width: 280, height: 400)
        .background(oneThingInfo.backgroundColor)
        .clipShape(.rect(cornerRadius: 20))
    }
}

#Preview {
    InMeetingOneThingView(inMeetingPathManager: .constant(OTInMeetingPathManager()))
}
