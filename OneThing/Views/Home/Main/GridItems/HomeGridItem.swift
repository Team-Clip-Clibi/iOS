//
//  HomeGridItem.swift
//  OneThing
//
//  Created by 오현식 on 5/9/25.
//

import SwiftUI

struct HomeGridItem: View {
    
    enum ConstText {
        static let onTheDay = "모임 당일"
        static let untilDay = "일 전"
    }
    
    private(set) var matchingSummary: MatchingSummaryInfo
    
    private var tintColor: Color {
        switch self.matchingSummary.category {
        case .onething: return .purple400
        case .random: return .green100
        case .instant: return .yellow100
        }
    }
    private var daysUntilMeetingText: String {
        if self.matchingSummary.daysUntilMeeting == 0 {
            return ConstText.onTheDay
        } else {
            return "\(self.matchingSummary.daysUntilMeeting)\(ConstText.untilDay)"
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Text(self.matchingSummary.category.description)
                .frame(maxWidth: .infinity, alignment: .leading)
                .otFont(.subtitle1)
                .foregroundStyle(.white100)
            
            self.setupItemView(
                .myMeetingTab,
                with: self.tintColor,
                text: self.daysUntilMeetingText
            )
            
            self.setupItemView(
                .locationFill,
                with: self.tintColor,
                text: self.matchingSummary.meetingPlace
            )
        }
        .padding(20)
        .frame(width: 192, height: 174)
        .background(self.tintColor)
        .clipShape(.rect(cornerRadius: 24))
    }
    
    func setupItemView(_ image: ImageResource, with color: Color, text: String) -> some View {
        
        return HStack {
            Image(image)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(color)
            
            Spacer()
            
            Text(text)
                .otFont(.subtitle2)
                .foregroundStyle(.gray800)
        }
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity)
        .frame(height: 44)
        .background(.white100)
        .clipShape(.rect(cornerRadius: 12))
    }
}

#Preview {
    HomeGridItem(
        matchingSummary: MatchingSummaryInfo(
            category: .onething,
            matchingId: 123456789,
            daysUntilMeeting: 0,
            meetingPlace: "Gangnam"
        )
    )
    HomeGridItem(
        matchingSummary: MatchingSummaryInfo(
            category: .random,
            matchingId: 123456789,
            daysUntilMeeting: 5,
            meetingPlace: "Gangnam"
        )
    )
    HomeGridItem(
        matchingSummary: MatchingSummaryInfo(
            category: .instant,
            matchingId: 123456789,
            daysUntilMeeting: 13,
            meetingPlace: "Gangnam"
        )
    )
}
