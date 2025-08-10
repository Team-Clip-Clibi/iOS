//
//  InMeetingSheetView.swift
//  OneThing
//
//  Created by 오현식 on 6/5/25.
//

import SwiftUI

struct InMeetingSheetView: View {
    
    @Environment(\.appCoordinator) var appCoordinator
    
    // @Binding var inMeetingPathManager: OTInMeetingPathManager
    // @Binding var inMeetingViewModel: InMeetingViewModel
    @Binding var isPresented: Bool
    
    let heightRatio: CGFloat
    let cornerRadius: CGFloat
    let backgroundColor: Color
    let dismissWhenBackgroundTapped: Bool
    
    @State private var height: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging: Bool = false
    
    var coordinator: InMeetingCoordinator? {
        return self.appCoordinator.childCoordinator.last as? InMeetingCoordinator
    }
    
    private let dismissThreshold: CGFloat = 0.8
    
    var body: some View {
        
        GeometryReader { geometry in
            
            self.backgroundColor
                // dimView 페이드 인/아웃
                .opacity(self.isPresented ? 1: 0)
                .onTapGesture {
                    if self.dismissWhenBackgroundTapped {
                        self.dismiss()
                    }
                }
                // bottom sheet alignment 조절을 위해 overlay로 설정
                .overlay(alignment: .bottom) {
                    VStack {
                        
                        Spacer().frame(height: 22)
                        
                        RoundedRectangle(cornerRadius: 2)
                            .fill(.gray400)
                            .frame(width: 32, height: 4)
                        
                        Spacer().frame(height: 22)
                        
                        // 모임 중 뷰
                        if let coordinator = self.coordinator, let path = coordinator.path.last {
                            
                            // coordinator.destinationView(to: path)
                        }
                        
                        // if let path = self.inMeetingPathManager.paths.last {
                        //     Group {
                        //         switch path {
                        //         case .main:
                        //             InMeetingMainView(
                        //                 inMeetingPathManager: $inMeetingPathManager,
                        //                 viewModel: $inMeetingViewModel
                        //             )
                        //         case .selectHost:
                        //             InMeetingSelectHostView(inMeetingPathManager: $inMeetingPathManager)
                        //         case .introduce:
                        //             InMeetingIntroduceView(
                        //                 inMeetingPathManager: $inMeetingPathManager,
                        //                 viewModel: $inMeetingViewModel
                        //             )
                        //         case .tmi:
                        //             InMeetingTMIView(
                        //                 inMeetingPathManager: $inMeetingPathManager,
                        //                 viewModel: $inMeetingViewModel
                        //             )
                        //         case .onething:
                        //             InMeetingOnethingView(
                        //                 inMeetingPathManager: $inMeetingPathManager,
                        //                 viewModel: $inMeetingViewModel
                        //             )
                        //         case .content:
                        //             InMeetingContentView(inMeetingPathManager: $inMeetingPathManager)
                        //         case .complete:
                        //             InMeetingCompleteView(
                        //                 inMeetingPathManager: $inMeetingPathManager,
                        //                 viewModel: $inMeetingViewModel
                        //             )
                        //         }
                        //     }
                        // }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: self.height)
                    .background(.white100)
                    .clipShape(.rect(topLeadingRadius: 20, topTrailingRadius: 20))
                    .offset(y: max(self.dragOffset, 0))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let height = value.location.y
                                
                                self.isDragging = true
                                self.dragOffset = height > 0 ? height: self.dragOffset
                            }
                            .onEnded { value in
                                self.isDragging = false
                                let dismissHeight = geometry.size.height * self.heightRatio * self.dismissThreshold
                                if value.location.y >= dismissHeight {
                                    self.dismiss()
                                } else {
                                    withAnimation(.spring()) {
                                        self.dragOffset = 0
                                    }
                                }
                            }
                    )
                    .task {
                        // 바텀 싯이 표시 될 때, main 화면을 표시하기 위해 사용
                        // if self.inMeetingPathManager.paths.isEmpty {
                        if let coordinator = self.coordinator, coordinator.path.isEmpty {
                            // self.inMeetingPathManager.paths.append(.main)
                            coordinator.push(to: .home(.inMeeting(.main)))
                        }
                    }
                    // path가 비었으면 모임이 완료되었다고 판단
                    // .onChange(of: self.inMeetingPathManager.paths.isEmpty) { old, new in
                    .onChange(of: coordinator?.path.isEmpty == true) { old, new in
                        if old == false, new {
                            self.dismiss()
                        }
                    }
                }
                .onAppear {
                    // 바텀 싯이 표시될 때, 애니메이션
                    withAnimation(.easeOut(duration: 0.3)) {
                        self.height = geometry.size.height * self.heightRatio
                    }
                }
        }
        .ignoresSafeArea()
    }
}

extension InMeetingSheetView {
    
    private func dismiss() {
        // 바텀 싯이 사라질 때, 애니메이션
        withAnimation(.easeIn(duration: 0.3)) {
            self.height = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isPresented = false
        }
    }
}
