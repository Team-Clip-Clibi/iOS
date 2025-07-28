//
//  UIApplication.swift
//  OneThing
//
//  Created by 오현식 on 7/26/25.
//

import SwiftUI

extension UIApplication {
    
    func endEditing() {
        self.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
