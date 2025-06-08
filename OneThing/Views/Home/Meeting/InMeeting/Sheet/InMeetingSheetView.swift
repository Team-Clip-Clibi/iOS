//
//  InMeetingSheetView.swift
//  OneThing
//
//  Created by 오현식 on 6/5/25.
//

import SwiftUI

struct InMeetingSheetView: View {
    
    @Binding var inMeetingPathManager: OTInMeetingPathManager
    @Binding var isPresented: Bool
    
    let heightRatio: CGFloat
    let cornerRadius: CGFloat
    let backgroundColor: Color
    let dismissWhenBackgroundTapped: Bool
    
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging: Bool = false
    
    private let dismissThreshold: CGFloat = 0.2
    
    var body: some View {
        
        GeometryReader { geometry in
            
            self.backgroundColor
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
                        
                        // 실제 모임 중 View
                        if let path = self.inMeetingPathManager.paths.last {
                            Group {
                                switch path {
                                case .main:
                                    InMeetingMainView(inMeetingPathManager: $inMeetingPathManager)
                                case .selectHost:
                                    InMeetingSelectHostView(inMeetingPathManager: $inMeetingPathManager)
                                case .introduce:
                                    InMeetingIntroduceView(inMeetingPathManager: $inMeetingPathManager)
                                case .tmi:
                                    InMeetingTMIView(inMeetingPathManager: $inMeetingPathManager)
                                case .oneThing:
                                    InMeetingOneThingView(inMeetingPathManager: $inMeetingPathManager)
                                case .content:
                                    InMeetingContentView(inMeetingPathManager: $inMeetingPathManager)
                                case .complete:
                                    InMeetingCompleteView(inMeetingPathManager: $inMeetingPathManager)
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .frame(height: geometry.size.height * self.heightRatio)
                    .background(.white100)
                    .clipShape(.rect(topLeadingRadius: 20, topTrailingRadius: 20))
                    .offset(y: max(self.dragOffset, 0))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let height = value.translation.height
                                
                                self.isDragging = true
                                self.dragOffset = height > 0 ? height: self.dragOffset
                            }
                            .onEnded { value in
                                self.isDragging = false
                                let dismissHeight = geometry.size.height * self.heightRatio * self.dismissThreshold
                                if value.translation.height >= dismissHeight {
                                    self.dismiss()
                                } else {
                                    withAnimation(.spring()) {
                                        self.dragOffset = 0
                                    }
                                }
                            }
                    )
                    .animation(self.isDragging ? nil: .spring(), value: self.dragOffset)
                    .task {
                        if self.inMeetingPathManager.paths.isEmpty {
                            self.inMeetingPathManager.paths.append(.main)
                        }
                    }
                    .onChange(of: self.inMeetingPathManager.paths.isEmpty) { old, new in
                        if old == false, new {
                            self.isPresented = false
                        }
                    }
                }
        }
        .ignoresSafeArea()
    }
}

extension InMeetingSheetView {
    
    private func dismiss() {
        withAnimation(.easeOut(duration: 0.2)) {
            self.isPresented = false
        }
    }
}
