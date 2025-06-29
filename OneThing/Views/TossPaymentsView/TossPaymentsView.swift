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
            if let _ = viewModel.oneThingResponse {
                contentBody
            } else {
                ProgressView("결제 정보를 불러오는 중입니다...")
            }
        }
        .toolbar { closeToolbar }
        .onChange(of: viewModel.processSuccess) { _, newValue in
            if let success = newValue {
                paymentResult = .success(success)
            }
        }
        .onChange(of: viewModel.processFail) { _, newValue in
            if let failure = newValue {
                paymentResult = .failure(failure)
            }
        }
        .onAppear {
            Task {
                try await self.viewModel.getOneThingOrder()
            }
        }
    }

    // 토스페이 결제하기 View
    private var contentBody: some View {
        VStack(spacing: 0) {
            ScrollView {
                PaymentMethodWidgetView(
                    widget: viewModel.widget,
                    amount: .init(value: Double(viewModel.oneThingResponse?.amount ?? 0))
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
                if let orderId = viewModel.oneThingResponse?.orderId {
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
    
    var oneThingResponse: OneThingOrderResponse?
    
    private let createOneThingOrderUseCase: CreateOneThingOrderUseCase
    private let confirmPaymentUseCase: ConfirmPaymentUseCase
    
    let widget: PaymentWidget = PaymentWidget(clientKey: "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm",
                                              customerKey: UUID().uuidString)
    
    init(createOneThingOrderUseCase: CreateOneThingOrderUseCase = CreateOneThingOrderUseCase(),
         confirmPaymentUseCase: ConfirmPaymentUseCase = ConfirmPaymentUseCase()) {
        self.createOneThingOrderUseCase = createOneThingOrderUseCase
        self.confirmPaymentUseCase = confirmPaymentUseCase
        widget.delegate = self
    }
    
    func getOneThingOrder() async throws {
        self.oneThingResponse = try await self.createOneThingOrderUseCase.execute(topic: "ㅂㅂㅂㅂㅂㅂㅂㅂ",
                                                                                  district: .gangnam,
                                                                                  preferredDates: [.init(date: "2025-07-06", timeSlot: .dinner)],
                                                                                  tmiContent: "ㅂㅂㅂㅂㅂㅂㅂㅂ",
                                                                                  oneThingBudgetRange: .high,
                                                                                  oneThingCategory: .health)
    }
    
    func confirmPayments() async throws {
        guard let result = processSuccess,
              let _ = oneThingResponse else {
            return
        }
        
        try await confirmPaymentUseCase.execute(
            paymentKey: result.paymentKey,
            orderId: result.orderId,
            orderType: .oneThing
        )
    }
    
    func requestPayment(info: WidgetPaymentInfo) {
        widget.requestPayment(info: info)
    }
    
    /// 결제 성공 시
    func handleSuccessResult(_ success: TossPaymentsResult.Success) {
        processSuccess = success
        Task {
            try await confirmPayments()
        }
        dump(success)
    }
    
    /// 결제 실패 시
    func handleFailResult(_ fail: TossPaymentsResult.Fail) {
        processFail = fail
        dump(fail)
    }
}
