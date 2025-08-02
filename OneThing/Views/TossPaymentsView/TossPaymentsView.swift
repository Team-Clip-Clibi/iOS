//
//  TossPaymentsView.swift
//  OneThing
//
//  Created by 윤동주 on 6/8/25.
//

import SwiftUI
import TossPayments

struct TossPaymentsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = TossPaymentsViewModel()
    @Binding var isShowingFullScreen: Bool
    @Binding var paymentResult: PaymentResult?
    @Binding var oneThingMatchingViewModel: OneThingMatchingViewModel
    
    var body: some View {
        NavigationStack {
            if let _ = viewModel.onethingResponse {
                contentBody
            } else {
                ProgressView("결제 정보를 불러오는 중입니다...")
            }
        }
        .toolbar { closeToolbar }
        .onChange(of: viewModel.processSuccess) { _, newValue in
            if let success = newValue {
                Task {
                    let isPaymentAPISuccess =  try await viewModel.confirmPayments()
                    if isPaymentAPISuccess {
                        paymentResult = .success(success)
                    } else {
                        // Toss 결제는 성공했으나 API 호출 시 에러 발생한 경우
                        paymentResult = .apiFailure
                    }
                }
            }
        }
        .onChange(of: viewModel.processFail) { _, newValue in
            if let failure = newValue {
                paymentResult = .failure(failure)
            }
        }
        .onAppear {
            Task {
                try await self.viewModel.getOnethingOrder(self.oneThingMatchingViewModel.currentState)
            }
        }
    }

    // 토스페이 결제하기 View
    private var contentBody: some View {
        VStack(spacing: 0) {
            ScrollView {
                PaymentMethodWidgetView(
                    widget: viewModel.widget,
                    amount: .init(value: Double(viewModel.onethingResponse?.amount ?? 0))
                )
                AgreementWidgetView(widget: viewModel.widget)
            }
            
            payButton
                .padding(.bottom, 24)
                .padding(.horizontal, 17)
            
        }
    }
    
    private var payButton: some View {
        Button {
            Task {
                if let orderId = viewModel.onethingResponse?.orderId {
                    viewModel.requestPayment(info: DefaultWidgetPaymentInfo(orderId: orderId,
                                                                            orderName: "원띵 결제하기"))
                }
            }
        } label: {
            Text("결제하기")
                .otFont(.title1)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.tossBlue)
                )
                .foregroundColor(.white100)
        }
    }

    private var closeToolbar: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("닫기") { isShowingFullScreen = false }
        }
    }
}

@Observable
final class TossPaymentsViewModel: TossPaymentsDelegate {
    var processSuccess: TossPaymentsResult.Success? = nil
    var processFail: TossPaymentsResult.Fail? = nil
    
    var onethingResponse: OnethingOrderResponse?
    
    private let submitOnethingsOrderUseCase: SubmitOnethingsOrderUseCase
    private let submitPaymentsConfirmUseCase: SubmitPaymentsConfirmUseCase
    
    let widget: PaymentWidget = PaymentWidget(
        clientKey: "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm",
        customerKey: UUID().uuidString
    )
    
    init(
        submitOnethingsOrderUseCase: SubmitOnethingsOrderUseCase = SubmitOnethingsOrderUseCase(),
        submitPaymentsConfirmUseCase: SubmitPaymentsConfirmUseCase = SubmitPaymentsConfirmUseCase()
    ) {
        self.submitOnethingsOrderUseCase = submitOnethingsOrderUseCase
        self.submitPaymentsConfirmUseCase = submitPaymentsConfirmUseCase
        widget.delegate = self
    }
    
    func getOnethingOrder(_ state: OneThingMatchingViewModel.State) async throws {
        do {
            let district: District = state.selectedDistrict.last!
            let preferredDates: [PreferredDate] = state.selectedDates.map {
                .init(date: $0.changeDateSeparator(from: ".", to: "-"), timeSlot: .dinner)
            }
            let oneThingBudgetRange: BudgetRange = state.selectedBudgetRange.last!
            let oneThingCategory: OneThingCategory = state.selectedCategory.last!
            let onethingOrderRequest = OnethingOrderRequest(
                topic: state.topicContent,
                district: district,
                preferredDates: preferredDates,
                tmiContent: state.tmiContent,
                oneThingBudgetRange: oneThingBudgetRange,
                oneThingCategory: oneThingCategory
            )
            
            self.onethingResponse = try await self.submitOnethingsOrderUseCase.execute(onethingOrderRequest)
        } catch {
            LoggingManager.error("OneThingOrderViewModel: getOneThingOrder Error: \(error)")
        }
        
    }
    
    func confirmPayments() async throws -> Bool {
        guard let result = processSuccess,
              let _ = onethingResponse else {
            return false
        }
        
        let paymentRequest = PaymentRequest(
            paymentKey: result.paymentKey,
            orderId: result.orderId,
            orderType: .onething
        )
        let isPaymentCompleted = try await submitPaymentsConfirmUseCase.execute(paymentRequest)
        return isPaymentCompleted
    }
    
    func requestPayment(info: WidgetPaymentInfo) {
        widget.requestPayment(info: info)
    }
    
    /// 결제 성공 시
    func handleSuccessResult(_ success: TossPaymentsResult.Success) {
        processSuccess = success
    }
    
    /// 결제 실패 시
    func handleFailResult(_ fail: TossPaymentsResult.Fail) {
        processFail = fail
        dump(fail)
    }
}
