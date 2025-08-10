//
//  MyPageReportStore.swift
//  OneThing
//
//  Created by 오현식 on 8/9/25.
//

import Foundation

@Observable
class MyPageReportStore: OTStore {
    
    enum Action: OTAction {
        case updateCategory(ReportCategory?)
        case submitReport(String)
    }
    
    enum Process: OTProcess {
        case updateCategory(ReportCategory?)
        case submitReport(Bool)
    }
    
    struct State: OTState {
        fileprivate(set) var reportCategory: ReportCategory?
        fileprivate(set) var isReported: Bool
    }
    var state: State
    
    private var submitReportUseCase: SubmitReportUseCase
    
    init(submitReportUseCase: SubmitReportUseCase) {
        
        self.state = State(
            reportCategory: nil,
            isReported: false
        )
        
        self.submitReportUseCase = submitReportUseCase
    }
    
    func process(_ action: Action) async -> OTProcessResult<Process> {
        switch action {
        case let .updateCategory(reportCategory):
            return .single(.updateCategory(reportCategory))
        case let .submitReport(content):
            return .none
        }
    }
    
    func reduce(state: State, process: Process) -> State {
        var newState = state
        switch process {
        case let .updateCategory(reportCategory):
            newState.reportCategory = reportCategory
        case let .submitReport(isReported):
            newState.isReported = isReported
        }
        return newState
    }
}

private extension MyPageReportStore {
    
    func submitReport(_ content: String) async -> OTProcessResult<Process> {
        do {
            guard let reportCategory = self.state.reportCategory else {
                return .single(.submitReport(false))
            }
            
            let isReported = try await self.submitReportUseCase.execute(
                content: content,
                reportCategory: reportCategory
            )
            
            return .single(.submitReport(isReported))
        } catch {
            
            return .single(.submitReport(false))
        }
    }
}
