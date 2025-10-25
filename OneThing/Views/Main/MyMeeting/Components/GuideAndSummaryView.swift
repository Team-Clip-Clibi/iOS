//
//  GuideAndSummaryView.swift
//  OneThing
//
//  Created by 오현식 on 9/8/25.
//

import SwiftUI

struct GuideAndSummaryView: View {
    
    enum Constants {
        enum Text {
            // 모임을 신청한 전적이 없을 때
            static let emptyMeetingGuideMessage: String = "첫 모임을 신청해 볼까요?"
            // 신청한 모임만 있을 때
            static let onlyAppliedMeetingGuideMessage: String = "을 위한 모임을 찾고 있어요\n확정까지 조금만 기다려 주세요"
            // 확정된 모임이 있을 때 (신청한 모임 여부 관계 X)
            static let nicknameGuideMessage: String = "님의"
            static let nextMeetingDateGuideMessage: String = "다음 모임은"
            // 모임을 완료한 전적이 있고, 신청한 모임/확정된 모임이 없을 때
            static let OnlyCompletedTitleMeetingGuideMessage: String = "참여한 원띵을 잘 간직하고 있어요\n다음 원띵을 찾아볼까요?"
            
            static let matchingAppliedsTitle: String = "신청완료"
            static let matchingConfirmedTitle: String = "모임확정"
        }
    }
    
    private(set) var status: MyMeetingStatus
    private(set) var nickname: String
    
    private var title: String {
        switch self.status.status {
        case .empty:
            return Constants.Text.emptyMeetingGuideMessage
        case .onlyApplied:
            return "\(self.nickname)\(Constants.Text.onlyAppliedMeetingGuideMessage)"
        case .onlyCompleted:
            return Constants.Text.OnlyCompletedTitleMeetingGuideMessage
        case .ConfirmedOrApplied:
            return "\(self.nickname)\(Constants.Text.nicknameGuideMessage)"
        }
    }
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            self.setupGuideMessage(self.status.status, title: self.title)
            
            HStack(spacing: 0) {
                
                self.setupSummaryView(
                    title: Constants.Text.matchingAppliedsTitle,
                    count: self.status.matchingApplieds
                )
                
                Rectangle()
                    .background(.gray300)
                    .frame(width: 1, height: 40)
                    
                self.setupSummaryView(
                    title: Constants.Text.matchingConfirmedTitle,
                    count: self.status.matchingConfirmeds
                )
            }
        }
        .padding(.horizontal, 16)
    }
}

extension GuideAndSummaryView {
    
    func setupGuideMessage(
        _ status: MyMeetingStatus.Status,
        title: String,
        nextMeetingDate: String? = nil
    ) -> some View {
        
        return Group {
            
            switch status {
            case .empty:
                Text(title)
                    .otFont(.title1)
                    .foregroundStyle(.gray800)
            case .onlyApplied, .onlyCompleted:
                Text(title)
                    .otFont(.title1)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.gray800)
            case .ConfirmedOrApplied:
                if let nextMeetingDate = nextMeetingDate {
                    VStack(spacing: 0) {
                        Text(title)
                            .otFont(.heading2)
                            .foregroundStyle(.gray800)
                        
                        Text("\(Constants.Text.nextMeetingDateGuideMessage)\(nextMeetingDate)")
                            .otFont(.heading2)
                            .foregroundStyle(.purple400)
                    }
                } else {
                    EmptyView()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func setupSummaryView(title: String, count: Int) -> some View {
        
        return ZStack {
            
            Color.gray100
            
            VStack(spacing: 0) {
                
                Text(title)
                    .otFont(.caption1)
                    .foregroundStyle(.gray600)
                
                Text("\(count)")
                    .otFont(.subtitle1)
                    .foregroundStyle(.gray800)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 68)
    }
}

extension GuideAndSummaryView {
    
    struct MyMeetingStatus {
        let status: Status
        let nextMeetingDateToString: String
        let matchingApplieds: Int
        let matchingConfirmeds: Int
        
        enum Status {
            case empty
            case onlyApplied
            case onlyCompleted
            case ConfirmedOrApplied
        }
    }
}
