//
//  MeetingListChipView.swift
//  OneThing
//
//  Created by 오현식 on 9/9/25.
//

import SwiftUI

struct MeetingListChipView: View {
    
    private(set) var title: String
    let onBackgroundTapped: ((Bool) -> Void)
    
    @State private var isSelected: Bool = false
    
    var body: some View {
        
        Text(self.title)
            .otFont(.caption1)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(self.isSelected ? .purple400: .white100)
            .foregroundStyle(self.isSelected ? .white100: .gray600)
            .clipShape(.rect(cornerRadius: 20))
            .onTapGesture {
                self.isSelected.toggle()
                self.onBackgroundTapped(self.isSelected)
            }
    }
}
