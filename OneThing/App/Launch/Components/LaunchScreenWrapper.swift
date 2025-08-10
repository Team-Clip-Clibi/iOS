//
//  LaunchScreenView.swift
//  OneThing
//
//  Created by 오현식 on 8/2/25.
//

import SwiftUI

struct LaunchScreenWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "Launch Screen", bundle: nil)
        return storyboard.instantiateInitialViewController() ?? UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}
