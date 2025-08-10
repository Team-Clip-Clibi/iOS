//
//  Tabbar.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import SwiftUI

struct OTTabItem: View {
    
    let title: String
    let imageResource: ImageResource
    
    var body: some View {
        
        VStack(spacing: 4) {
            Image(self.imageResource)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.gray500)
            
            Text(self.title)
                .otFont(.caption1)
                .foregroundStyle(.gray500)
        }
        .frame(width: 64, height: 46)
    }
}
