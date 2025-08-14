//
//  MyPageEditRelationshipViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 8/9/25.
//

import SwiftUI

struct MyPageEditRelationshipViewBuilder: OTViewBuildable {
    
    typealias Store = MyPageEditStore
    typealias Content = MyPageEditRelationshipView
    
    var matchedPath: OTPath = .myPage(.editRelationship)
    
    func build(store: Binding<MyPageEditStore>) -> MyPageEditRelationshipView {
        MyPageEditRelationshipView(store: store)
    }
}
