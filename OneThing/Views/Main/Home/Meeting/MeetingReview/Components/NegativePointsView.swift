//
//  NegativePointsView.swift
//  OneThing
//
//  Created by 오현식 on 6/10/25.
//

import SwiftUI

struct NegativePointsView: View {
    
    let title: String
    
    @Binding var isSelected: Bool
    @Binding var nagativePoints: [NegativePoint]
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            Text(self.title)
                .otFont(.subtitle1)
                .foregroundStyle(.gray800)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            MultipleCheckBoxView<NegativePoint>(
                viewType: .meeting,
                state: .init(items: NegativePoint.allCases.map { .init(item: $0) }),
                isReachedLimit: .constant(false),
                isSelected: $isSelected,
                selectedItems: $nagativePoints
            )
        }
    }
}

#Preview {
    NegativePointsView(
        title: "title",
        isSelected: .constant(false),
        nagativePoints: .constant([])
    )
}
