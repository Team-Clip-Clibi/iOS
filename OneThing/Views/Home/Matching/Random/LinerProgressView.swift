//
//  LinerProgressView.swift
//  OneThing
//
//  Created by 오현식 on 5/15/25.
//

import SwiftUI

struct LinerProgressView<Shape: SwiftUI.Shape>: View {
    
    let value: Double
    let shape: Shape
    let height: CGFloat = 6
    
    var body: some View {
        self.shape
            .fill(.gray200)
            .overlay(alignment: .leading) {
                GeometryReader { geometry in
                    self.shape
                        .fill(.tint)
                        .frame(width: geometry.size.width * self.value)
                }
            }
            .frame(height: self.height)
            .clipShape(self.shape)
    }
}

#Preview {
    LinerProgressView(value: 0.3, shape: Rectangle())
        .tint(.purple400)
    LinerProgressView(value: 0.3, shape: Capsule())
}
