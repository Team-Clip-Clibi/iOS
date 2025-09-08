//
//  MemberInfo.swift
//  OneThing
//
//  Created by 오현식 on 6/29/25.
//

import Foundation

// 매칭 쪽 SelectableItem을 상속하기 위해 정의
struct MemberInfo: Identifiable, Equatable {
    
    let member: String
    
    var id: String { UUID().uuidString }
}
