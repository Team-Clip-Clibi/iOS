//
//  MeetingListCellView.swift
//  OneThing
//
//  Created by 오현식 on 9/9/25.
//

import SwiftUI

struct MeetingListCellView: View {
    
    enum Constants {
        enum Text {
            static let toDetailButtonTitle: String = "자세히보기"
            
            static let matchingApplied: String = "신청완료"
            static let matchingConfirmed: String = "모임확정"
            static let matchingFinished: String = "모임종료"
            static let matchingCancelled: String = "취소"
            
            static let onething: String = "원띵모임"
            static let random: String = "랜덤모임"
            static let instant: String = "번개모임"
            
            static let dot: String = "•"
            
            static let writeReviewButtonTitle: String = "후기 작성하기"
        }
    }
    
    private(set) var matchingInfo: MatchingInfo
    let onDetailButtonTapped: (() -> Void)
    let onWriteReviewButtonTapped: ((MatchingInfo) -> Void)
    
    private var matchingStatusToKorean: String {
        switch self.matchingInfo.matchingStatus {
        case .applied   : return Constants.Text.matchingApplied
        case .confirmed : return Constants.Text.matchingConfirmed
        case .canceled  : return Constants.Text.matchingCancelled
        default         : return Constants.Text.matchingFinished
        }
    }
    
    private var matchingTypeToKorean: String {
        switch self.matchingInfo.matchingType {
        case .onething  : return Constants.Text.onething
        case .random    : return Constants.Text.random
        case .instant   : return Constants.Text.instant
        }
    }
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Text(self.matchingInfo.meetingTime.toString("yyyy.MM.dd"))
                    .otFont(.caption1)
                    .foregroundStyle(.gray800)
                
                Spacer()
                
                Button(action: { self.onDetailButtonTapped() }) {
                    
                    HStack(spacing: 4) {
                        
                        Text(Constants.Text.toDetailButtonTitle)
                            .otFont(.caption1)
                            .foregroundStyle(.gray700)
                        
                        Image(.rightArrowOutlined)
                            .resizable()
                            .frame(width: 18, height: 18)
                            .foregroundStyle(.gray500)
                    }
                }
            }
            .frame(height: 26)
            
            Spacer().frame(height: 4)
            
            HStack(spacing: 6) {
                
                Text(self.matchingStatusToKorean)
                    .otFont(.caption1)
                    .foregroundStyle(self.matchingInfo.matchingStatus == .canceled ? .red100: .purple400)
                
                Text(Constants.Text.dot)
                    .otFont(.caption1)
                    .foregroundStyle(.gray800)
                
                Text(self.matchingTypeToKorean)
                    .otFont(.caption1)
                    .foregroundStyle(.gray800)
            }
            
            Spacer().frame(height: 10)
            
            Rectangle()
                .fill(.gray400)
                .frame(height: 1)
            
            Spacer().frame(height: 10)
            
            Text(self.matchingInfo.myOneThingContent)
                .otFont(.subtitle1)
                .foregroundStyle(.gray800)
                .lineLimit(1)
                .truncationMode(.tail)
            
            if self.matchingInfo.matchingStatus == .completed {
                
                Spacer().frame(height: 14)
                
                OTLButton(
                    buttonTitle: Constants.Text.writeReviewButtonTitle,
                    action: { self.onWriteReviewButtonTapped(self.matchingInfo) },
                    isClicked: self.matchingInfo.isReviewWritten == false
                )
            }
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .frame(height: 131)
    }
}
