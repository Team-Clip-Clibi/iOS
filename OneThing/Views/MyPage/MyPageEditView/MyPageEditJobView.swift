//
//  MyPageEditJobView.swift
//  OneThing
//
//  Created by 윤동주 on 4/24/25.
//

import SwiftUI

struct MyPageEditJobView: View {
    
    @State private var isLimitErrorHighlighted = false
    @State private var shakeTrigger: CGFloat = 0
    @State private var jobInfo: [JobType] = []
    
    @Binding var pathManager: OTAppPathManager
    @Binding var viewModel: MyPageEditViewModel
    
    private let columns = [
        GridItem(.flexible()), GridItem(.flexible())
    ]
    
    private let maxSelection = 2
    
    
    
    var body: some View {
        VStack(spacing: 0) {
            OTNavigationBar(
                rightButtonType: .close,
                title: "하는 일 변경",
                phase: 0,
                rightAction: {
                    _ = self.pathManager.myPagePaths.popLast()
                }
            )
            
            VStack(spacing: 0) {
                HStack {
                    Text("최대 2개까지 선택할 수 있어요.")
                        .otFont(.subtitle2)
                        .fontWeight(.semibold)
                        .foregroundColor(isLimitErrorHighlighted ? .red100 : .gray600)
                        .animation(.easeInOut(duration: 0.3), value: isLimitErrorHighlighted)
                        .padding(.top, 32)
                    
                    Spacer()
                }
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(JobType.allCases) { job in
                        OTSelectionButton(buttonTitle: job.toKorean, action: {
                            toggle(job)
                        }, isClicked: self.jobInfo.contains(job))
                    }
                }
                .padding(.top, 24)
                
                Spacer()
            }
            .padding(.horizontal, 17)
            
            Rectangle()
                .fill(.gray200)
                .frame(height: 1)
            OTXXLButton(
                buttonTitle: "완료",
                action: {
                    Task {
                        viewModel.jobInfo = self.jobInfo
                        
                        let result = try await viewModel.updateJob()
                        
                        if result {
                            pathManager.pop()
                        }
                    }
                },
                isClickable: self.jobInfo.count != 0)
            .padding(.horizontal, 17)
            .padding(.top, 10)
        }
        .task {
            Task {
                self.jobInfo = viewModel.jobInfo

                pathManager.isTabBarHidden = true
            }
        }
        .onDisappear {
            pathManager.isTabBarHidden = false
        }
        .navigationBarBackButtonHidden()
    }
    
    private func toggle(_ job: JobType) {
        if let index = self.jobInfo.firstIndex(of: job) {
            self.jobInfo.remove(at: index) // 선택된 선택지 제거
        } else if self.jobInfo.count < maxSelection {
            self.jobInfo.append(job) // 최대 선택 개수보다 적을 경우 추가
        } else {
            withAnimation {
                isLimitErrorHighlighted = true
                HapticManager.shared.notification(type: .error)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isLimitErrorHighlighted = false
                }
            }
        }
    }
}

#Preview {
    MyPageEditJobView(pathManager: .constant(OTAppPathManager()), viewModel: .constant(MyPageEditViewModel()))
}
