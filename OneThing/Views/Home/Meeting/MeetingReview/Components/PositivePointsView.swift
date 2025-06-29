//
//  PositivePointsView.swift
//  OneThing
//
//  Created by 오현식 on 6/10/25.
//

import SwiftUI

struct PositivePointsView: View {
    
    let title: String
    let messages: [String]
    
    @Binding var isSelected: Bool
    @Binding var positivePoints: [String]
    
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
                selectedTitles: $positivePoints
            )
        }
    }
}

#Preview {
    PositivePointsView(
        title: "title",
        messages: [
            "대화가 흥미로웠어요",
            "멤버들이 적극적으로 참여했어요",
            "진행이 매끄러웠어요",
            "분위기가 편안하고 즐거웠어요",
            "시간과 장소가 적절했어요"
        ],
        isSelected: .constant(false),
        positivePoints: .constant([])
    )
}
