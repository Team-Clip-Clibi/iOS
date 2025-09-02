//
//  InMeetingFloatingView.swift
//  OneThing
//
//  Created by 오현식 on 5/31/25.
//

import SwiftUI

struct InMeetingFloatingView: View {
    
    enum Constants {
        enum Text {
            static let title = "모임이 진행 중이에요"
            static let message = "지금까지 나눈 이야기, 다시 이어가요"
        }
    }
    
    var onBackgroundTapped: (() -> Void)?
    
    var body: some View {
        
        HStack {
            
            Image(.teamFill)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(.purple200)
            
            Spacer().frame(width: 16)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(Constants.Text.title)
                    .otFont(.subtitle2)
                    .foregroundStyle(.white100)
                
                Text(Constants.Text.message)
                    .otFont(.body3)
                    .foregroundStyle(.gray300)
            }
            
            Spacer()
            
            Image(.rightArrowOutlined)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(.white100)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .frame(height: 74)
        .background(.gray700)
        .clipShape(.rect(cornerRadius: 50))
        .onTapGesture { self.onBackgroundTapped?() }
    }
}

#Preview {
    InMeetingFloatingView(onBackgroundTapped: { })
        .padding(.horizontal, 16)
}
