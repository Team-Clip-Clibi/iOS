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
    
    @Binding var isShowingFullScreen: Bool
    @Binding var onethingMatchingStore: OnethingMatchingStore
    
    var body: some View {
        NavigationStack {
            if let _ = self.onethingMatchingStore.state.onethingResponse {
                contentBody
            } else {
                ProgressView("결제 정보를 불러오는 중입니다...")
            }
        }
        .toolbar { closeToolbar }
        .onChange(of: self.onethingMatchingStore.state.resultSucess) { _, newValue in
            if let success = newValue {
                Task {
                    await self.onethingMatchingStore.send(.confirmPayment)
                }
            }
        }
        .taskForOnce {
            await self.onethingMatchingStore.send(.requsetOrder)
        }
    }

    // 토스페이 결제하기 View
    private var contentBody: some View {
        VStack(spacing: 0) {
            ScrollView {
                PaymentMethodWidgetView(
                    widget: self.onethingMatchingStore.widget,
                    amount: .init(value: Double(self.onethingMatchingStore.state.onethingResponse?.amount ?? 0))
                )
                AgreementWidgetView(widget: self.onethingMatchingStore.widget)
            }
            
            payButton
                .padding(.bottom, 24)
                .padding(.horizontal, 17)
            
        }
    }
    
    private var payButton: some View {
        Button {
            Task {
                await self.onethingMatchingStore.send(.requestPayment)
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
