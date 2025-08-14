//
//  DateTextBoxStyle.swift
//  OneThing
//
//  Created by 오현식 on 5/20/25.
//

import SwiftUI

struct DateTextBoxStyle: ToggleStyle {
    
    let matchingDate: (String, String)
    var backgroundTapAction: ((Configuration) -> Void)? = nil
    
    func makeBody(configuration: Configuration) -> some View {
        
        Button {
            self.backgroundTapAction?(configuration)
        } label: {
            
            VStack {
                Spacer().frame(height: 15)
                
                VStack(spacing: 2) {
                    Text(self.matchingDate.1)
                        .otFont(.body1)
                        .foregroundStyle(.gray800)
                    
                    Text(self.matchingDate.0)
                        .otFont(.subtitle1)
                        .foregroundStyle(.gray800)
                }
                
                Spacer()
                
                ZStack {
                    configuration.isOn ? Color.purple200: Color.gray200
                    
                    configuration.label
                        .otFont(.caption1)
                        .foregroundStyle(.gray700)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 30)
            }
            .frame(width: 88, height: 108)
            .background(configuration.isOn ? .purple100: .gray100)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(configuration.isOn ? .purple200: .gray100, lineWidth: 1)
            )
            .clipShape(.rect(cornerRadius: 8))
        }
    }
}

struct DateTextBoxForPreview: View {
    
    @State var isOn: Bool = false
    var isSelectable: Bool = true
    
    var body: some View {
        
        Toggle("디너 7시", isOn: $isOn)
            .toggleStyle(DateTextBoxStyle(matchingDate: ("05.20", "금")))
    }
}

#Preview {
    DateTextBoxForPreview()
    DateTextBoxForPreview(isOn: true)
}
