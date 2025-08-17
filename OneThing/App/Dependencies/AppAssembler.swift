//
//  AppAssembler.swift
//  OneThing
//
//  Created by 오현식 on 8/2/25.
//

import Foundation

final class AppAssembler: OTAssemblerable {
    
    func assemble(container: OTDIContainerable) {
        container.register(SessionStoring.self) { _ in
            UserDefaultsSessionStore()
        }
        
        container.register(AuthRepository.self) { _ in
            AuthRepository()
        }
        
        container.register(AppStateManager.self) { _ in
            AppStateManager()
        }
    }
}
