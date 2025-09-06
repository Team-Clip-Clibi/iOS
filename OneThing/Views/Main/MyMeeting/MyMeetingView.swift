//
//  MyMeetingView.swift
//  OneThing
//
//  Created by 윤동주 on 4/4/25.
//

import SwiftUI

struct MyMeetingView: View {
    @State private var selectionTab: Int = MyMeetingTabMenu.meetingDetails.selectedTab
    @State private var viewModel: MyMeetingViewModel = MyMeetingViewModel()
    
    @Binding var appPathManager: OTAppPathManager
    
    var body: some View {
        ScrollView {
            VStack(spacing:0) {
                VStack(alignment: .leading) {
                    Text("내 모임")
                        .otFont(.title1)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                    
                    Text("민만밈님의")
                        .otFont(.heading1)
                        .fontWeight(.bold)
                        .foregroundStyle(.gray800)
                        .padding(.top, 26)
                    
                    Text("다음 모임은 3월 24일")
                        .otFont(.heading1)
                        .fontWeight(.bold)
                        .foregroundStyle(.purple400)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.gray100)
                            .frame(maxWidth: .infinity, minHeight: 68)
                        HStack {
                            Spacer()
                            
                            VStack(spacing: 0) {
                                Text("신청완료")
                                    .otFont(.caption1)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.gray600)
                                
                                Text("1")
                                    .otFont(.subtitle1)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.gray800)
                            }
                            
                            Spacer()
                            
                            Divider()
                                .foregroundStyle(.gray300)
                                .frame(width: 1, height: 40)
                            
                            Spacer()
                            
                            VStack(spacing: 0) {
                                Text("매칭확정")
                                    .otFont(.caption1)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.gray600)
                                
                                Text("2")
                                    .otFont(.subtitle1)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.gray800)
                            }
                            
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 17)
                
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    Section(header: MyStickyHeader(selectionTab: $selectionTab)) {
                        switch selectionTab {
                        case 0:
                            VStack(spacing: 0) {
                                ChipBarView()
                                VStack(spacing: 12) {
                                    ForEach(self.viewModel.matchingInfo.indices, id: \.self) { index in
                                        CheckBox()
                                    }
                                }
                                
                                ZStack {
                                    Divider()
                                        .background(.gray400)
                                    Text("지난 내역")
                                        .otFont(.body2)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.gray700)
                                        .padding(.horizontal, 12)
                                        .background(.gray200)
                                }
                                
                                VStack(spacing: 3) {
                                    ForEach(0..<3) { index in
                                        CheckBox()
                                    }
                                }
                            }
                            .padding(.bottom, 20)
                            .padding(.horizontal, 17)
                            .background(.gray200)
                        case 1:
                            ForEach(0..<3) { index in
                                Text("Item \(index)")
                                    .padding()
                                    .background(Color.blue.opacity(0.3))
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                            }
                            .padding(.bottom, 20)
                        default:
                            EmptyView()
                        }
                        
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .padding(.top, 0.5)
        .onAppear {
            Task {
                try await self.viewModel.getAllMyMeeting()
            }
        }
    }
}

struct MyStickyHeader: View {
    
    @Binding var selectionTab: Int
    
    var body: some View {
        HStack {
            SlidingTabView(selection: $selectionTab,
                           tabs: MyMeetingTabMenu.allCases.map { $0.categoryTitle })
            .frame(width: 200)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(.white100)
    }
}

struct ChipBarView: View {
    @State private var selectedIndex: Int = 0
    private let tabs = ["전체", "신청완료", "모임확정", "모임종료", "취소"]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 6) {
                ForEach(Array(tabs.enumerated()), id: \.offset) { idx, title in
                    Text(title)
                        .font(.caption1)
                        .fontWeight(.semibold)
                        .foregroundColor(selectedIndex == idx
                                         ? .white100
                                         : .gray600)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(selectedIndex == idx
                                      ? .purple400
                                      : .white100)
                        )
                        .onTapGesture {
                            withAnimation { selectedIndex = idx }
                        }
                }
                Spacer()
            }
        }
        .scrollIndicators(.hidden)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MyMeetingView(
        appPathManager: .constant(OTAppPathManager())
    )
}
