//
//  NegativePointsView.swift
//  OneThing
//
//  Created by 오현식 on 6/10/25.
//

import SwiftUI

struct NegativePointsView: View {
    
    let title: String
    let messages: [String]
    
    @Binding var isSelected: Bool
    @Binding var nagativePoints: [String]
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            Text(self.title)
                .otFont(.subtitle1)
                .foregroundStyle(.gray800)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            MultipleCheckBoxView(
                viewType: .meeting,
                state: .init(items: self.messages.map { .init(title: $0) }),
                isReachedLimit: .constant(false),
                isSelected: $isSelected,
                selectedTitles: $nagativePoints
            )
        }
    }
}

#Preview {
    NegativePointsView(
        title: "title",
        messages: [
            "대화가 지루했어요",
            "멤버들이 소극적이었어요",
            "진행이 이해하기 어려웠어요",
            "분위기가 어색하거나 불편했어요",
            "시간과 장소가 마음에 안들어요",
            "약속 시간을 지키지 않은 멤버가 많았어요"
        ],
        isSelected: .constant(false),
        nagativePoints: .constant([])
    )
}
