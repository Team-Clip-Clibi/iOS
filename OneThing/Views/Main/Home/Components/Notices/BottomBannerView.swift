//
//  BottomBannerView.swift
//  OneThing
//
//  Created by 오현식 on 8/23/25.
//

import SwiftUI
import Combine

struct BottomBannerView: View {
    
    enum Constants {
        /// 임의의 타이머 interval, 4초
        static let timerInterval: TimeInterval = 4
    }
    
    @State private var currentIndex: Int = 0
    
    private(set) var bannerInfos: [HomeBannerInfo]
    private let timer = Timer.publish(
        every: Constants.timerInterval,
        on: .main,
        in: .common
    ).autoconnect()
    
    var body: some View {
        
        if self.bannerInfos.isEmpty == false {
        
            VStack(spacing: 10) {
                TabView(selection: $currentIndex) {
                    ForEach(
                        0..<self.bannerInfos.count,
                        id: \.self
                    ) { page in
                        let urlString = self.bannerInfos[page].urlString
                        self.setupBanner(with: urlString)
                            .tag(page)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                // TODO: TabView 애니메이션이 겹치기 때문에 modifier 사용 X
                .onReceive(self.timer) { _ in
                    let newIndex = (self.currentIndex + 1) % self.bannerInfos.count
                    self.currentIndex = newIndex
                }
                .animation(.easeInOut(duration: 0.4), value: self.currentIndex)
                
                HStack(spacing: 6) {
                    ForEach(
                        0..<self.bannerInfos.count,
                        id: \.self
                    ) { page in
                        Circle()
                            .fill(page == self.currentIndex ? .purple400: .gray400)
                            .frame(width: 6, height: 6)
                            .animation(.easeInOut(duration: 0.2), value: self.currentIndex)
                    }
                }
            }
            // 초기 높이, 이미지 높이 추정 전
            .frame(height: 136)
        } else {
            EmptyView()
        }
    }
}

private extension BottomBannerView {
    
    func setupBanner(with urlString: String) -> some View {
        
        return AsyncSVGImage(urlString: urlString, shape: .rounded(8))
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .frame(height: 110)
            .disabled(true)
    }
}

#Preview {
    BottomBannerView(bannerInfos: [
        HomeBannerInfo(id: "1", urlString: "https://s3.ap-northeast-2.amazonaws.com/clibi.onething/banner/Banner_1.svg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20250823T081120Z&X-Amz-SignedHeaders=host&X-Amz-Credential=AKIAWN26JWMGRKALDOE6%2F20250823%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Expires=86400&X-Amz-Signature=a5fd6827ef1d92641b6e4bf0f46020f3f62774fa624fdf83fc32d119115637dd"),
        HomeBannerInfo(id: "2", urlString: "https://s3.ap-northeast-2.amazonaws.com/clibi.onething/banner/Banner_2.svg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20250823T081120Z&X-Amz-SignedHeaders=host&X-Amz-Credential=AKIAWN26JWMGRKALDOE6%2F20250823%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Expires=86400&X-Amz-Signature=94bb8a2283c7c1d048d5849a72f47018eba2850cc02a8713743d52b095834ab9")
    ])
}
