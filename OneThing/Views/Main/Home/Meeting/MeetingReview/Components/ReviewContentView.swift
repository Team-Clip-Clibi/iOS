//
//  ReviewContentView.swift
//  OneThing
//
//  Created by 오현식 on 6/10/25.
//

import SwiftUI

struct ReviewContentView: View {
    
    enum Constants {
        enum Text {
            static let reviewContentTitle: String = "자세한 경험을 알려주세요"
            static let reviewPlaceholder: String = "소중한 의견을 남겨주세요 (선택사항)"
        }
    }
    
    @Binding var reviewContent: String
    
    var body: some View {
        
        VStack {
            
            Text(Constants.Text.reviewContentTitle)
                .otFont(.subtitle1)
                .foregroundColor(.gray800)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer().frame(height: 16)
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.gray300, lineWidth: 1)
                
                TextEditor(text: $reviewContent)
                    .otFont(.body2)
                    .foregroundColor(.gray800)
                    .tint(.purple400)
                    .multilineTextAlignment(.leading)
                    .contentMargins(.all, 16)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    // 기본 배경색을 표시하기 위해, 스크롤 백그라운드 숨김
                    .scrollContentBackground(.hidden)
                    .overlay(
                        Text(Constants.Text.reviewPlaceholder)
                            .otFont(.body2)
                            .foregroundColor(self.reviewContent.isEmpty ? .gray500: .clear)
                            .padding(24)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    )
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .frame(height: 152)
        }
    }
}

#Preview {
    ReviewContentView(reviewContent: .constant(""))
}
