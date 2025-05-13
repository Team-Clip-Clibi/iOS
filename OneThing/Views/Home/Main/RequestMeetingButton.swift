//
//  MeetingButton.swift
//  OneThing
//
//  Created by 오현식 on 5/9/25.
//

import SwiftUI

struct RequestMeetingButton: View {
    
    enum Category: String {
        
        enum ConstText {
            static let onethingTitle = "원띵 모임"
            static let randomTitle = "랜덤 모임"
            static let instantTitle = "번개 모임"
            
            static let onethingDescription = "대화하고 싶은 단 하나의 주제를 나눠요"
            static let randomDescription = "주제없이 만나요"
            static let instantDescription = "오늘 만날 수 있어요"
        }
        
        case onething
        case random
        case instant
        
        var title: String {
            switch self {
            case .onething:
                return ConstText.onethingTitle
            case .random:
                return ConstText.randomTitle
            case .instant:
                return ConstText.instantTitle
            }
        }
        
        var image: ImageResource {
            switch self {
            case .onething:
                return .onething
            case .random:
                return .random
            case .instant:
                return .instant
            }
        }
        
        var description: String {
            switch self {
            case .onething:
                return ConstText.onethingDescription
            case .random:
                return ConstText.randomDescription
            case .instant:
                return ConstText.instantDescription
            }
        }
    }
    
    private(set) var category: Category
    
    private(set) var backgroundTapAction: (() -> Void)
    
    var body: some View {
        HStack {
            if self.category == .onething {
                ZStack {
                    Color.purple100
                    
                    Image(self.category.image)
                        .resizable()
                        .frame(width: 38, height: 38)
                        .foregroundStyle(.purple400)
                }
                .frame(width: 56, height: 56)
                .clipShape(.rect(cornerRadius: 12))
            } else {
                Image(self.category.image)
                    .resizable()
                    .frame(width: 36, height: 36)
            }
            
            Spacer().frame(width: self.category == .onething ? 16: 12)
            
            VStack(alignment: .leading) {
                Text(self.category.title)
                    .otFont(.subtitle2)
                    .foregroundStyle(.gray800)
                
                Spacer().frame(height: 2)
                
                Text(self.category.description)
                    .otFont(.caption1)
                    .foregroundStyle(.gray600)
            }
            
            Spacer()
        }
        .padding(.horizontal,self.category == .onething ? 18: 16)
        .frame(maxWidth: .infinity)
        .frame(height: 84)
        .background(.white100)
        .clipShape(.rect(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(.gray100, lineWidth: 1)
        )
        .onTapGesture { self.backgroundTapAction() }
    }
}

#Preview {
    RequestMeetingButton(category: .onething, backgroundTapAction: { })
    HStack(spacing: 10) {
        RequestMeetingButton(category: .random, backgroundTapAction: { })
        RequestMeetingButton(category: .instant, backgroundTapAction: { })
    }
}
