//
//  PositivePointsView.swift
//  OneThing
//
//  Created by 오현식 on 6/10/25.
//

import SwiftUI

struct PositivePointsView: View {
    
    let title: String
    
    @Binding var isSelected: Bool
    @Binding var positivePoints: [PositivePoint]
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            Text(self.title)
                .otFont(.subtitle1)
                .foregroundStyle(.gray800)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            MultipleCheckBoxView<PositivePoint>(
                viewType: .meeting,
                state: .init(items: PositivePoint.allCases.map { .init(item: $0) }),
                isReachedLimit: .constant(false),
                isSelected: $isSelected,
                selectedItems: $positivePoints
            )
        }
    }
}

#Preview {
    PositivePointsView(
        title: "title",
        isSelected: .constant(false),
        positivePoints: .constant([])
    )
}
