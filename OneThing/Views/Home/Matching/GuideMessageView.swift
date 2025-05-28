//
//  GuideMessageView.swift
//  OneThing
//
//  Created by 오현식 on 5/20/25.
//

import SwiftUI

struct GuideMessageView: View {
    
    @Binding var isChangeSubTitleColor: Bool
    
    let title: String
    var subTitle: String? = nil
    
    var body: some View {
        VStack(spacing: 2) {
            Text(self.title)
                .otFont(.heading2)
                .multilineTextAlignment(.leading)
                .foregroundStyle(.gray800)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let subTitle = self.subTitle {
                Text(subTitle)
                    .otFont(.subtitle2)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(self.isChangeSubTitleColor == true ? .red100: .gray600)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                EmptyView()
            }
        }
    }
}

#Preview {
    GuideMessageView(
        isChangeSubTitleColor: .constant(false),
        title: "타이틀"
    )
    GuideMessageView(
        isChangeSubTitleColor: .constant(false),
        title: "타이틀",
        subTitle: "서브타이틀"
    )
    GuideMessageView(
        isChangeSubTitleColor: .constant(true),
        title: "타이틀",
        subTitle: "서브타이틀"
    )
}
