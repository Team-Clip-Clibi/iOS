//
//  MyPageEditDietaryViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/9/25.
//

import SwiftUI

struct MyPageEditDietaryViewBuilder: OTViewBuildable {
    
    typealias Store = MyPageEditStore
    typealias Content = MyPageEditDietaryView
    
    var matchedPath: OTPath = .myPage(.editDiet)
    
    func build(store: Binding<MyPageEditStore>) -> MyPageEditDietaryView {
        MyPageEditDietaryView(store: store)
    }
}
