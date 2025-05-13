//
//  TopBannerView.swift
//  OneThing
//
//  Created by 오현식 on 5/10/25.
//

import SwiftUI

struct TopBannerView: View {
    
    private(set) var description: String
    private(set) var title: String
    
    private(set) var closeTapAction: (() -> Void)
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(self.description)
                    .otFont(.body1)
                    .foregroundStyle(.gray700)
                
                Text(self.title)
                    .otFont(.subtitle1)
                    .foregroundStyle(.purple400)
            }
            
            Spacer(minLength: 25)
            
            Button(
                action: { self.closeTapAction() },
                label: {
                    Image(.closeOutlined)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.gray500)
                }
            )
        }
        .padding(.horizontal, 18)
        .frame(maxWidth: .infinity)
        .frame(height: 82)
        .background(.white100)
        .clipShape(.rect(cornerRadius: 14))
    }
}

#Preview {
    TopBannerView(
        description: "모임 매칭이 완료되었어요! 참석 여부를 알려주세요",
        title: "참석 결정하기",
        closeTapAction: { }
    )
}
