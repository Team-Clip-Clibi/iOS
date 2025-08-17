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
        
        static let onethingDescription = "원띵 모임"
        static let randomDescription = "랜덤 모임"
        static let instantDescription = "번개 모임"
    }
    
    private(set) var matchingType: MatchingType
    private(set) var matchingSummary: MatchingSummaryInfo
    
    private var tintColor: Color {
        switch self.self.matchingType {
        case .onething: return .purple400
        case .random:   return .green100
        case .instant:  return .yellow100
        }
    }
    private var daysUntilMeetingText: String {
        switch self.matchingSummary.daysUntilMeeting {
        case 0:     return ConstText.onTheDay
        default:    return "\(self.matchingSummary.daysUntilMeeting)\(ConstText.untilDay)"
        }
    }
    private var matchingTypeDescription: String {
        switch self.matchingType {
        case .onething: return ConstText.onethingDescription
        case .random:   return ConstText.randomDescription
        case .instant:  return ConstText.instantDescription
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Text(self.matchingTypeDescription)
                .frame(maxWidth: .infinity, alignment: .leading)
                .otFont(.subtitle1)
                .foregroundStyle(.white100)
            
            self.setupItemView(
                .myMeetingFill,
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
        matchingType: .onething,
        matchingSummary: MatchingSummaryInfo(
            matchingId: 1,
            daysUntilMeeting: 0,
            meetingTime: Date(),
            meetingPlace: "Gangnam"
        )
    )
    HomeGridItem(
        matchingType: .random,
        matchingSummary: MatchingSummaryInfo(
            matchingId: 2,
            daysUntilMeeting: 10,
            meetingTime: Date(),
            meetingPlace: "Gangnam"
        )
    )
    HomeGridItem(
        matchingType: .instant,
        matchingSummary: MatchingSummaryInfo(
            matchingId: 3,
            daysUntilMeeting: 5,
            meetingTime: Date(),
            meetingPlace: "Gangnam"
        )
    )
}
