//
//  RandomMatchingAssembler.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import Foundation

final class RandomMatchingAssembler: OTAssemblerable {
    
    let nickname: String
    
    init(with nickname: String) {
        self.nickname = nickname
    }
    
    func assemble(container: OTDIContainerable) {
        container.register(RandomMatchingStore.self) { _ in
            RandomMatchingStore(with: self.nickname)
        }
    }
}
