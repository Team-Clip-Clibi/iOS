//
//  MyPageReportAssembler.swift
//  OneThing
//
//  Created by 오현식 on 8/10/25.
//

import Foundation

final class MyPageReportAssembler: OTAssemblerable {
    
    func assemble(container: OTDIContainerable) {
        container.register(ReportRepository.self) { _ in
            ReportRepository()
        }
        container.register(SubmitReportUseCase.self) { resolver in
            SubmitReportUseCase(repository: resolver.resolve(ReportRepository.self))
        }
        
        container.register(MyPageReportStore.self) { resolver in
            MyPageReportStore(submitReportUseCase: resolver.resolve(SubmitReportUseCase.self))
        }
    }
}
