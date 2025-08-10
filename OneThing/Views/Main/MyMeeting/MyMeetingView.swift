//
//  MyMeetingView.swift
//  OneThing
//
//  Created by 윤동주 on 4/4/25.
//

import SwiftUI

struct MyMeetingView: View {
    @Binding var appPathManager: OTAppPathManager
    
    var body: some View {
        Text("MyMeetingView")
        
    }
}

#Preview {
    MyMeetingView(appPathManager: .constant(OTAppPathManager()))
}
