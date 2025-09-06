//
//  CheckBox.swift
//  OneThing
//
//  Created by 윤동주 on 5/21/25.
//

import SwiftUI

struct CheckBox: View {
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                HStack {
                    Text("2025.03.09")
                        .otFont(.caption1)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray800)
                    Spacer()
                    Button {
                        
                    } label: {
                        HStack(spacing: 11) {
                            Text("자세히보기")
                                .otFont(.caption1)
                                .fontWeight(.semibold)
                                .foregroundStyle(.gray700)
                            Image(.rightArrow)
                                .foregroundStyle(.gray500)
                        }
                    }
                }
                
                HStack(spacing: 6) {
                    Text("신청완료")
                        .otFont(.caption1)
                        .fontWeight(.semibold)
                        .foregroundStyle(.purple400)
                    Text("•")
                        .otFont(.caption1)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray800)
                    Text("랜덤모임")
                        .otFont(.caption1)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray800)
                    Spacer()
                }
                .padding(.top, 4)
                
                Divider()
                    .background(.gray400)
                    .padding(.top, 10)
                
                VStack(spacing: 14) {
                    HStack {
                        Text("다들 면접 준비는 어떻게 하시나요?")
                            .otFont(.subtitle1)
                            .fontWeight(.semibold)
                            .foregroundStyle(.gray800)
                            .padding(.top, 10)
                        
                        Spacer()
                    }
                 
                    OTCenterLButton(
                        buttonTitle: "후기 작성하기",
                        action: {
                            
                        },
                        isClickable: true
                    )
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 18)
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity)
        .background(.gray100)
        .clipShape(
            RoundedRectangle(cornerRadius: 12)
        )
    }
}

#Preview {
    CheckBox()
}
