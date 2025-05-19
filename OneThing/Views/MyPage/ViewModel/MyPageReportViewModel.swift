//
//  MyPageReportViewModel.swift
//  OneThing
//
//  Created by 윤동주 on 5/6/25.
//

import Foundation

@Observable
class MyPageReportViewModel {
    
    // MARK: - Properties
    
    var content: String = ""
    var reportCategory: ReportCategory?
    
    private var submitReportUseCase: SubmitReportUseCase
    
    // MARK: - Initializer
    
    init(submitReportUseCase: SubmitReportUseCase = SubmitReportUseCase()) {
        self.submitReportUseCase = submitReportUseCase
    }
    
    // MARK: - Functions
    
    func submitReport() async throws -> Bool {
        
        guard let reportCategory = reportCategory else {
            return false
        }
        
        return try await submitReportUseCase.execute(content: content, reportCategory: reportCategory)
    }
    
    func initReport() {
        self.content = ""
        self.reportCategory = nil
    }

}
