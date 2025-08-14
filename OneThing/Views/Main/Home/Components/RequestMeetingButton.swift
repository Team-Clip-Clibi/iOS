//
//  MeetingButton.swift
//  OneThing
//
//  Created by 오현식 on 5/9/25.
//

import SwiftUI

struct RequestMeetingButton: View {
    
    enum ConstText {
        static let onethingTitle = "원띵 모임"
        static let randomTitle = "랜덤 모임"
        static let instantTitle = "번개 모임"
        
        static let onethingDescription = "대화하고 싶은 나만의 주제를 나눠요"
        static let randomDescription = "매주 월요일 7시"
        static let instantDescription = "오픈 예정이에요"
    }
    
    private(set) var matchingType: MatchingType
    private(set) var backgroundTapAction: (() -> Void)
    
    private var title: String {
        switch self.matchingType {
        case .onething: return ConstText.onethingTitle
        case .random:   return ConstText.randomTitle
        case .instant:  return ConstText.instantTitle
        }
    }
    private var image: ImageResource {
        switch self.matchingType {
        case .onething: return .onething
        case .random:   return .random
        case .instant:  return .instant
        }
    }
    private var description: String {
        switch self.matchingType {
        case .onething: return ConstText.onethingDescription
        case .random:   return ConstText.randomDescription
        case .instant:  return ConstText.instantDescription
        }
    }
    
    var body: some View {
        HStack {
            Image(self.image)
                .resizable()
                .frame(width: 44, height: 44)
            
            Spacer().frame(width: self.matchingType == .onething ? 16: 12)
            
            VStack(alignment: .leading) {
                Text(self.title)
                    .otFont(.subtitle2)
                    .foregroundStyle(.gray800)
                
                Spacer().frame(height: 2)
                
                Text(self.description)
                    .otFont(.caption1)
                    .foregroundStyle(.gray600)
            }
            
            Spacer()
        }
        .padding(.horizontal,self.matchingType == .onething ? 18: 16)
        .frame(maxWidth: .infinity)
        .frame(height: 84)
        .background(.white100)
        .clipShape(.rect(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray100, lineWidth: 1)
        )
        .onTapGesture { self.backgroundTapAction() }
    }
}

#Preview {
    ZStack {
        Color.gray100
        
        VStack(spacing: 12) {
            RequestMeetingButton(matchingType: .onething, backgroundTapAction: { })
            HStack(spacing: 12) {
                RequestMeetingButton(matchingType: .random, backgroundTapAction: { })
                RequestMeetingButton(matchingType: .instant, backgroundTapAction: { })
            }
        }
    }
}
