//
//  BottomBannerView.swift
//  OneThing
//
//  Created by 오현식 on 8/23/25.
//

import SwiftUI
import Combine

import SDWebImageSwiftUI

struct BottomBannerView: View {
    
    enum Constants {
        /// 임의의 타이머 interval, 4초
        static let timerInterval: TimeInterval = 4
    }
    
    @State private var currentIndex: Int = 0
    @State private var hasTimerStopped: Bool = false
    
    private(set) var bannerInfos: [HomeBannerInfo]
    
    private let timer = Timer.publish(
        every: Constants.timerInterval,
        on: .main,
        in: .common
    ).autoconnect()
    
    var body: some View {
        
        if self.bannerInfos.count > 1 {
        
            VStack(spacing: 10) {
                
                let dragGesture = DragGesture(minimumDistance: 0)
                    .onChanged { _ in self.hasTimerStopped = true }
                    .onEnded { _ in self.hasTimerStopped = false }
                
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 16) {
                            ForEach(
                                0..<self.bannerInfos.count,
                                id: \.self
                            ) { index in
                                
                                let urlString = self.bannerInfos[index].urlString
                                self.setupBanner(with: urlString)
                                    .tag(index)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .contentMargins(.horizontal, 16, for: .scrollContent)
                    .scrollTargetBehavior(.viewAligned)
                    .scrollPosition(id: Binding($currentIndex))
                    .gesture(dragGesture)
                    .onChange(of: self.currentIndex) { _, new in
                        guard self.hasTimerStopped == false else { return }
                        
                        withAnimation(.easeInOut(duration: 0.8)) {
                            proxy.scrollTo(new)
                        }
                    }
                    .onReceive(self.timer) { _ in
                        guard self.hasTimerStopped == false else { return }
                        
                        self.currentIndex = (self.currentIndex + 1) % self.bannerInfos.count
                    }
                }
                
                self.setupIndicator(total: self.bannerInfos.count, current: self.currentIndex)
            }
            // 초기 높이, 이미지 높이 추정 전
            .frame(height: 136)
        } else {
            if let urlString = self.bannerInfos.last?.urlString {
                self.setupBanner(with: urlString)
            } else {
                EmptyView()
            }
        }
    }
}

private extension BottomBannerView {
    
    func setupBanner(with urlString: String) -> some View {
        
        return RoundedRectangle(cornerRadius: 8)
            .fill(.clear)
            .containerRelativeFrame(.horizontal)
            .frame(height: 110)
            .overlay {
                WebImage(url: URL(string: urlString))
                    .resizable()
            }
            .clipShape(.rect(cornerRadius: 8))
    }
    
    func setupIndicator(total totalIndex: Int, current currentIndex: Int) -> some View {
        
        return HStack(spacing: 6) {
            ForEach(0..<totalIndex, id: \.self) { index in
                Circle()
                    .fill(index == currentIndex ? .purple400: .gray400)
                    .frame(width: 6, height: 6)
            }
        }
    }
}

#Preview {
    BottomBannerView(bannerInfos: [
        HomeBannerInfo(id: "1", urlString: "https://s3.ap-northeast-2.amazonaws.com/clibi.onething/banner/Banner_1.svg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20250823T081120Z&X-Amz-SignedHeaders=host&X-Amz-Credential=AKIAWN26JWMGRKALDOE6%2F20250823%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Expires=86400&X-Amz-Signature=a5fd6827ef1d92641b6e4bf0f46020f3f62774fa624fdf83fc32d119115637dd"),
        HomeBannerInfo(id: "2", urlString: "https://s3.ap-northeast-2.amazonaws.com/clibi.onething/banner/Banner_2.svg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20250823T081120Z&X-Amz-SignedHeaders=host&X-Amz-Credential=AKIAWN26JWMGRKALDOE6%2F20250823%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Expires=86400&X-Amz-Signature=94bb8a2283c7c1d048d5849a72f47018eba2850cc02a8713743d52b095834ab9")
    ])
}
