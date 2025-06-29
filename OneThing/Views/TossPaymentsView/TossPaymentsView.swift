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

    var body: some View {
        NavigationStack {
            contentBody
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
    }

    // 토스페이 결제하기 View
    private var contentBody: some View {
        VStack(spacing: 0) {
            ScrollView {
                PaymentMethodWidgetView(widget: viewModel.widget,
                                        amount: .init(value: 1))
                AgreementWidgetView(widget: viewModel.widget)
            }
            
            payButton
                .padding(.bottom, 24)
                .padding(.horizontal, 17)
            
        }
    }
    
    private var payButton: some View {
        Button {
            viewModel.requestPayment(info: DefaultWidgetPaymentInfo(orderId: "UserID",
                                                                    orderName: "원띵 결제하기"))
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
    
    let widget: PaymentWidget = PaymentWidget(clientKey: "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm",
                                              customerKey: UUID().uuidString)
    
    init() {
        widget.delegate = self
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
    }
}
