//
//  ClearBackgroundView.swift
//  OneThing
//
//  Created by 오현식 on 6/17/25.
//

import SwiftUI

struct ClearBackgroundView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}
