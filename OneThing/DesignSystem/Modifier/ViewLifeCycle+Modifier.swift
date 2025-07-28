//
//  ViewLifeCycle+Modifier.swift
//  OneThing
//
//  Created by 오현식 on 7/27/25.
//

import SwiftUI

struct TaskForOnceViewModifier: ViewModifier {
    
    @State private var isLoaded = false
    let perform: () -> Void
    
    func body(content: Content) -> some View {
        content
            .task {
                if self.isLoaded == false {
                    self.isLoaded = true
                    self.perform()
                }
            }
    }
}

extension View {
    
    func taskForOnce(_ perform: @escaping () -> Void) -> some View {
        self.modifier(TaskForOnceViewModifier(perform: perform))
    }
}
