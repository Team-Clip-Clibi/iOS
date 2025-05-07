//
//  HomeView.swift
//  OneThing
//
//  Created by 윤동주 on 4/4/25.
//

import SwiftUI

struct HomeView: View {
    @Binding var appPathManager: OTAppPathManager
    
    var body: some View {
        Text("HomeView")
        
    }
}

#Preview {
    HomeView(appPathManager: .constant(OTAppPathManager()))
}
