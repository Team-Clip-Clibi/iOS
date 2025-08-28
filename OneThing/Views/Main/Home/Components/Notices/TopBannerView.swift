//
//  TopBannerView.swift
//  OneThing
//
//  Created by 오현식 on 5/10/25.
//

import SwiftUI

struct TopBannerView: View {
    
    private(set) var bannerInfos: [NotificationBannerInfo]
    private(set) var onCloseTapped: ((String) -> Void)
    
    @State private var displayedBannerInfos: [NotificationBannerInfo] = []
    @State private var currentIndex: Int = 0
    
    var body: some View {
        
        if self.bannerInfos.isEmpty == false {
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(
                        self.displayedBannerInfos,
                        id: \.id
                    ) { bannerInfo in
                        let index = self.displayedBannerInfos.firstIndex(where: { $0.id == bannerInfo.id }) ?? 0
                        self.setupBanner(
                            self.displayedBannerInfos[index],
                            total: self.displayedBannerInfos.count,
                            current: index,
                            onCloseTapped: self.onCloseTapped
                        )
                        .tag(index)
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(.horizontal, 16, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: Binding($currentIndex))
            .onAppear { self.displayedBannerInfos = self.bannerInfos }
        } else {
            EmptyView()
        }
    }
}

private extension TopBannerView {
    
    func setupBanner(
        _ bannerInfo: NotificationBannerInfo,
        total totalIndex: Int,
        current currentIndex: Int,
        onCloseTapped: @escaping ((String) -> Void)
    ) -> some View {
        
        return HStack {
            
            VStack(alignment: .leading, spacing: 4) {
                Text(bannerInfo.bannerType.description)
                    .otFont(.body1)
                    .foregroundStyle(.gray700)
                
                HStack {
                    
                    Text(bannerInfo.bannerType.title)
                        .otFont(.subtitle1)
                        .foregroundStyle(.purple400)
                    
                    Spacer()
                    
                    if totalIndex == 1 {
                        EmptyView()
                    } else {
                        self.setupIndicator(total: totalIndex, current: currentIndex)
                    }
                }
            }
            
            Spacer().frame(maxWidth: 25)
            
            ZStack {
                
                Image(.closeOutlined)
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(.gray500)
            }
            .frame(width: 34, height: 34)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.4)) {
                    self.displayedBannerInfos.removeAll(where: { $0.id == bannerInfo.id })
                }
                onCloseTapped(bannerInfo.id)
            }
        }
        .padding(.vertical, 16)
        .padding(.leading, 18)
        .padding(.trailing, 10)
        .frame(height: 82)
        .containerRelativeFrame(.horizontal)
        .background(.white100)
        .clipShape(.rect(cornerRadius: 14))
    }
    
    func setupIndicator(total totalIndex: Int, current currentIndex: Int) -> some View {
        
        return Text("\(currentIndex+1)/\(totalIndex)")
            .otFont(.caption2)
            .foregroundStyle(.purple400)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.purple100)
                    .frame(width: 35, height: 22)
            )
    }
}

#Preview {
    ZStack {
        Color.gray
        
        TopBannerView(
            bannerInfos: [
                NotificationBannerInfo(id: "1", bannerType: .matching),
                NotificationBannerInfo(id: "2", bannerType: .matchingInfo)
            ],
            onCloseTapped: { _ in }
        )
    }
}
