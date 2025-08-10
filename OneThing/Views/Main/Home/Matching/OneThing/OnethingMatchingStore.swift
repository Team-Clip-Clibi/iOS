//
//  OnethingMatchingStore.swift
//  OneThing
//
//  Created by 오현식 on 8/3/25.
//

import Foundation

import TossPayments

@Observable
class OnethingMatchingStore: OTStore {
    
    enum Action: OTAction {
        case updateCategory(OneThingCategory?)
        case updateDistrict(District?)
        case updateBudgetRange(BudgetRange?)
        case updateDates([String])
        case updateTopicContents(String)
        case updateTmiContents(String)
        
        case requsetOrder
        case requestPayment
        case confirmPayment
        case updateResultSucess(TossPaymentsResult.Success)
        case updateResultFail(TossPaymentsResult.Fail)
    }
    
    enum Process: OTProcess {
        case updateCategory(OneThingCategory?)
        case updateDistrict(District?)
        case updateBudgetRange(BudgetRange?)
        case updateDates([String])
        case updateTopicContents(String)
        case updateTmiContents(String)
        
        case updateOrderResponse(OnethingOrderResponse?)
        case updateResultSucess(TossPaymentsResult.Success?)
        case updateResultFail(TossPaymentsResult.Fail?)
        case updateIsPaymentCompleted(Bool)
    }
    
    struct State: OTState {
        fileprivate(set) var selectedCategory: OneThingCategory?
        fileprivate(set) var selectedDistrict: District?
        fileprivate(set) var selectedBudgetRange: BudgetRange?
        fileprivate(set) var selectedDates: [String]
        fileprivate(set) var topicContents: String
        fileprivate(set) var tmiContents: String
        
        // 토스 페이먼트
        fileprivate(set) var resultSucess: TossPaymentsResult.Success?
        fileprivate(set) var resultFail: TossPaymentsResult.Fail?
        fileprivate(set) var paymentResult: PaymentResult?
        fileprivate(set) var onethingResponse: OnethingOrderResponse?
        fileprivate(set) var isPaymentCompleted: Bool
    }
    var state: State
    
    private let submitOnethingsOrderUseCase: SubmitOnethingsOrderUseCase
    private let submitPaymentsConfirmUseCase: SubmitPaymentsConfirmUseCase
    
    let widget: PaymentWidget
    
    init(
        submitOnethingsOrderUseCase: SubmitOnethingsOrderUseCase,
        submitPaymentsConfirmUseCase: SubmitPaymentsConfirmUseCase
    ) {
        
        self.state = State(
            selectedCategory: nil,
            selectedDistrict: nil,
            selectedBudgetRange: nil,
            selectedDates: [],
            topicContents: "",
            tmiContents: "",
            resultSucess: nil,
            resultFail: nil,
            paymentResult: nil,
            onethingResponse: nil,
            isPaymentCompleted: false
        )
        
        self.submitOnethingsOrderUseCase = submitOnethingsOrderUseCase
        self.submitPaymentsConfirmUseCase = submitPaymentsConfirmUseCase
        
        self.widget = PaymentWidget(
            clientKey: "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm",
            customerKey: UUID().uuidString
        )
        self.widget.delegate = self
    }
    
    func process(_ action: Action) async -> OTProcessResult<Process> {
        switch action {
        case let .updateCategory(selectedCategory):
            return .single(.updateCategory(selectedCategory))
        case let .updateDistrict(selectedDistrict):
            return .single(.updateDistrict(selectedDistrict))
        case let .updateBudgetRange(selectedBudgetRange):
            return .single(.updateBudgetRange(selectedBudgetRange))
        case let .updateDates(selectedDates):
            return .single(.updateDates(selectedDates))
        case let .updateTopicContents(topicContents):
            return .single(.updateTopicContents(topicContents))
        case let .updateTmiContents(tmiContents):
            return .single(.updateTmiContents(tmiContents))
        case .requsetOrder:
            return await self.requestOrder()
        case .requestPayment:
            return await self.requestPayments()
        case .confirmPayment:
            return await self.confirmPayments()
        case let .updateResultSucess(success):
            return .single(.updateResultSucess(success))
        case let .updateResultFail(fail):
            return .single(.updateResultFail(fail))
        }
    }
    
    func reduce(state: State, process: Process) -> State {
        var newState = state
        switch process {
        case let .updateCategory(selectedCategory):
            newState.selectedCategory = selectedCategory
        case let .updateDistrict(selectedDistrict):
            newState.selectedDistrict = selectedDistrict
        case let .updateBudgetRange(selectedBudgetRange):
            newState.selectedBudgetRange = selectedBudgetRange
        case let .updateDates(selectedDates):
            newState.selectedDates = selectedDates
        case let .updateTopicContents(topicContents):
            newState.topicContents = topicContents
        case let .updateTmiContents(tmiContents):
            newState.tmiContents = tmiContents
        case let .updateOrderResponse(onethingOrderResponse):
            newState.onethingResponse = onethingOrderResponse
        case let .updateResultSucess(success):
            newState.resultSucess = success
            
            if let success = success {
                newState.paymentResult = .success(success)
            }
        case let .updateResultFail(fail):
            newState.resultFail = fail
            
            if let fail = fail {
                newState.paymentResult = .failure(fail)
            }
        case let .updateIsPaymentCompleted(isPaymentCompleted):
            newState.isPaymentCompleted = isPaymentCompleted
            
            if isPaymentCompleted == false {
                newState.paymentResult = .apiFailure
            }
        }
        return newState
    }
}

extension OnethingMatchingStore: TossPaymentsDelegate {
    
    func handleSuccessResult(_ success: TossPaymentsResult.Success) {
        Task {
            await self.send(.updateResultSucess(success))
        }
    }
    
    func handleFailResult(_ fail: TossPaymentsResult.Fail) {
        Task {
            await self.send(.updateResultFail(fail))
        }
        dump(fail)
    }
}

private extension OnethingMatchingStore {
    
    func requestOrder() async -> OTProcessResult<Process> {
        
        do {
            guard let district = self.state.selectedDistrict,
                  let oneThingBudgetRange = self.state.selectedBudgetRange,
                  let oneThingCategory = self.state.selectedCategory
            else { return .none }
            
            let preferredDates: [PreferredDate] = self.state.selectedDates.map {
                PreferredDate(date: $0.changeDateSeparator(from: ".", to: "-"), timeSlot: .dinner)
            }
            let onethingOrderRequest = OnethingOrderRequest(
                topic: self.state.topicContents,
                district: district,
                preferredDates: preferredDates,
                tmiContent: self.state.tmiContents,
                oneThingBudgetRange: oneThingBudgetRange,
                oneThingCategory: oneThingCategory
            )
            
            let onethingResponse = try await self.submitOnethingsOrderUseCase.execute(onethingOrderRequest)
            return .single(.updateOrderResponse(onethingResponse))
        } catch {
            return .single(.updateOrderResponse(nil))
        }
    }
    
    func requestPayments() async -> OTProcessResult<Process> {
        
        guard let orderId = self.state.onethingResponse?.orderId else { return .none }
        
        let info = DefaultWidgetPaymentInfo(orderId: orderId, orderName: "원띵 결제하기")
        self.widget.requestPayment(info: info)
        
        return .none
    }
    
    func confirmPayments() async -> OTProcessResult<Process> {
        
        do {
            guard let resultSucess = self.state.resultSucess,
                  self.state.onethingResponse != nil
            else { return .none }
            
            let paymentRequest = PaymentRequest(
                paymentKey: resultSucess.paymentKey,
                orderId: resultSucess.orderId,
                orderType: .onething
            )
            
            let isPaymentCompleted = try await self.submitPaymentsConfirmUseCase.execute(paymentRequest)
            return .single(.updateIsPaymentCompleted(isPaymentCompleted))
        } catch {
            return .single(.updateIsPaymentCompleted(false))
        }
    }
}
