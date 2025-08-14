//
//  InMeetingGuideMessageView.swift
//  OneThing
//
//  Created by 오현식 on 6/2/25.
//

import SwiftUI

struct InMeetingGuideMessageView: View {
    
    let title: String
    let subTitle: String
    let message: String
    
    var body: some View {
            
        VStack {
            Text(self.title)
                .otFont(.caption1)
                .foregroundColor(.purple400)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer().frame(height: 2)
            
            Text(self.subTitle)
                .font(.heading3)
                .foregroundColor(.gray800)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer().frame(height: 12)
            
            Text(message)
                .font(.subtitle2)
                .foregroundColor(.gray700)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 24)
    }
}
