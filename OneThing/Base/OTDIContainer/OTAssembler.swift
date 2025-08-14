//
//  OTAssembler.swift
//  OneThing
//
//  Created by 오현식 on 7/29/25.
//

import Foundation

/// 여러 의존성 등록 로직을 한 곳에 모아 관리하는 책임을 가집니다.
protocol OTAssemblerable {
    func assemble(container: OTDIContainerable)
}

/// `OTAssemblerable`의 실제 구현 클래스입니다.
final class OTAppAssembler: OTAssemblerable {
    
    func assemble(container: OTDIContainerable) {
        /*
         TODO: 필요한 의존성 주입
         1. Repository: container.register(AnyRespository.self) { _ in AnyRespository() }
         2. UseCase: container.register(AnyUseCase.self) { resolver in AnyUseCase(resolver.resolve(AnyRespository.self)) }
         3. Store: container.register(OTStore.self) { resolver in AnyStore(resolver.resolve(AnyUseCase.self)) }
        */
    }
}
