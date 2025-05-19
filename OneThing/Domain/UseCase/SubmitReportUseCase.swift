//
//  SubmitReportUseCase.swift
//  OneThing
//
//  Created by 윤동주 on 5/11/25.
//

import Foundation

struct SubmitReportUseCase {
    private let repository: ReportRepository
    
    init(repository: ReportRepository = ReportRepository()) {
        self.repository = repository
    }
    
    func execute(
        content: String,
        reportCategory: ReportCategory
    ) async throws -> Bool {
        let statusCode = try await repository.report(
            with:
                ReportDTO(
                    content: content,
                    reportCategory: reportCategory
                )
        ).statusCode
        return statusCode == 204
    }
}
