//
//  MeetingReviewGuideMeesageView.swift
//  OneThing
//
//  Created by 오현식 on 6/10/25.
//

import SwiftUI

struct MeetingReviewGuideMeesageView: View {
    
    enum Constants {
        enum Text {
            static let title: String = "모임은 어떠셨나요?"
            static let prevSubTitle: String = "솔직한 후기를 남겨 주시면 큰 도움이 됩니다. 작성하신 후기는 원띵과 본인만 확인할 수 있어요."
            static let nextSubTitle: String = "솔직한 후기를 남겨 주시면 큰 도움이 되어요\n작성하신 후기는 원띵과 본인만 확인할 수 있어요"
            
        }
    }
    
    @Binding var isReviewSelected: Bool
    
    var body: some View {
        
        VStack(spacing: 12) {
            
            Text(Constants.Text.title)
                .otFont(.heading3)
                .foregroundStyle(.gray800)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            let subTitle = self.isReviewSelected ? Constants.Text.nextSubTitle : Constants.Text.prevSubTitle
            Text(subTitle)
                .otFont(.subtitle2)
                .foregroundStyle(.gray700)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    MeetingReviewGuideMeesageView(isReviewSelected: .constant(false))
}
