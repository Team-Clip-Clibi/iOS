//
//  SlidingTabView.swift
//  OneThing
//
//  Created by 윤동주 on 6/29/25.
//

import SwiftUI


enum MyMeetingTabMenu: String, CaseIterable {
    case meetingDetails = "모임 내역"
    case notice = "안내문"
    
    var categoryTitle: String {
        return self.rawValue
    }
    var selectedTab: Int {
        switch self {
        case .meetingDetails:
            return 0
        case .notice:
            return 1
        }
    }
}

public struct SlidingTabView: View {
    @Binding var selection: Int
    
    let tabs: [String]
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                ForEach(Array(self.tabs.enumerated()), id:\.element) { index, tab in
                    Button {
                        withAnimation {
                            let selection = self.tabs.firstIndex(of: tab) ?? 0
                            self.selection = selection
                        }
                    } label: {
                        HStack {
                            Spacer()
                            
                            Text(tab)
                                .otFont(.subtitle2)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .overlay(
                            Group {
                                if index == 1 {
                                    Circle()
                                        .frame(width: 6, height: 6)
                                        .foregroundStyle(.red)
                                        .offset(x: -18, y: -3)
                                }
                            },
                            alignment: .topTrailing
                        )
                    }
                    .padding(.vertical, 16)
                    .tint(index == selection ? .gray800 : .gray600)
                }
                
            }
            GeometryReader { geometry in
                ZStack(alignment: .bottomLeading) {
                    Rectangle()
                        .fill(.gray200)
                        .frame(width: geometry.size.width,
                               height: 1,
                               alignment: .leading)
                    Rectangle()
                        .fill(.gray800)
                        .frame(width: self.tabWidth(from: geometry.size.width),
                               height: 2,
                               alignment: .leading)
                        .offset(x: self.selectionBarXOffset(from: geometry.size.width),
                                y: 0)
                        .animation(.bouncy, value: selection)
                }
            }
            .frame(height: 2)
        }
        .padding(.horizontal, 17)
    }
    
    
    private func isSelected(tabIdentifier: String) -> Bool {
        return tabs[selection] == tabIdentifier
    }
    
    private func selectionBarXOffset(from totalWidth: CGFloat) -> CGFloat {
        return self.tabWidth(from: totalWidth) * CGFloat(selection)
    }
    
    private func tabWidth(from totalWidth: CGFloat) -> CGFloat {
        return totalWidth / CGFloat(tabs.count)
    }
}


#Preview {
    SlidingTabView(selection: .constant(0), tabs: ["모임 내역", "안내문"])
}
