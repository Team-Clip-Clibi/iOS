//
//  OnethingMatchingAssembler.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import Foundation

final class OnethingMatchingAssembler: OTAssemblerable {
    
    func assemble(container: OTDIContainerable) {
        container.register(OnethingMatchingRepository.self) { _ in
            OnethingMatchingRepository()
        }
        container.register(SubmitOnethingsOrderUseCase.self) { resolver in
            SubmitOnethingsOrderUseCase(repository: resolver.resolve(OnethingMatchingRepository.self))
        }
        
        container.register(PaymentsRepository.self) { _ in
            PaymentsRepository()
        }
        container.register(SubmitPaymentsConfirmUseCase.self) { resolver in
            SubmitPaymentsConfirmUseCase(repository: resolver.resolve(PaymentsRepository.self))
        }
        
        container.register(OnethingMatchingStore.self) { resolver in
            OnethingMatchingStore(
                submitOnethingsOrderUseCase: resolver.resolve(SubmitOnethingsOrderUseCase.self),
                submitPaymentsConfirmUseCase: resolver.resolve(SubmitPaymentsConfirmUseCase.self)
            )
        }
    }
}
