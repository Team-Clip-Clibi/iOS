//
//  UserDefaults+Matching.swift
//  OneThing
//
//  Created by 오현식 on 5/21/25.
//

import Foundation

extension UserDefaults {
    
    // 모임 신청이 처음인지 확인
    static var isFirstMatching: Bool {
        
        let hasBeenMatchedBefore = "hasBeenMatchedBefore"
        let isFirstMatching = UserDefaults.standard.bool(forKey: hasBeenMatchedBefore) == false
        
        if isFirstMatching {
            UserDefaults.standard.set(true, forKey: hasBeenMatchedBefore)
            UserDefaults.standard.synchronize()
        }
        
        return isFirstMatching
    }
}
