//
//  MyPageEditRelationshipView.swift
//  OneThing
//
//  Created by 윤동주 on 5/4/25.
//

//
//  MyPageEditJobView.swift
//  OneThing
//
//  Created by 윤동주 on 4/24/25.
//

import SwiftUI

struct MyPageEditRelationshipView: View {

    @State private var status: RelationshipStatus?
    @State private var isConsidered: Bool?
    
    @Binding var pathManager: OTAppPathManager
    @Binding var viewModel: MyPageEditViewModel
    
    private let considerOptions = [
        (true, "같은 상태인 사람만 만나고 싶어요"),
        (false, "연애 상태는 신경쓰지 않아도 괜찮아요")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            OTNavigationBar(
                rightButtonType: .close,
                title: "연애 상태 변경",
                phase: 0,
                rightAction: {
                    _ = self.pathManager.myPagePaths.popLast()
                }
            )
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("연애 상태")
                        .otFont(.caption1)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray800)
                    
                    VStack(spacing: 10) {
                        ForEach(RelationshipStatus.allCases) { status in
                            OTLButton(
                                buttonTitle: status.toKorean,
                                action: { self.status = status },
                                isClicked: self.status == status
                            )
                        }
                    }
                }
                .padding(.top, 32)
                
                Rectangle()
                    .fill(.gray200)
                    .frame(height: 1)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("모임 매칭시 연애 상태 고려 여부")
                        .otFont(.caption1)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray800)
                    
                    VStack(spacing: 12) {
                        ForEach(considerOptions, id: \.0) { selected, title in
                            OTLButton(
                                buttonTitle: title,
                                action: { self.isConsidered = selected },
                                isClicked: self.isConsidered == selected
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, 17)
            
            Spacer()
            
            Rectangle()
                .fill(.gray200)
                .frame(height: 1)
            
            OTXXLButton(
                buttonTitle: "완료",
                action: {
                    Task {
                        self.viewModel.relationship = RelationshipInfo(
                            status: self.status,
                            isConsidered: self.isConsidered
                        )
                        let result = try await viewModel.updateRelationship()
                        if result {
                            pathManager.pop()
                        }
                    }
                },
                isClickable: self.status != nil && self.isConsidered != nil)
            .padding(.horizontal, 17)
            .padding(.top, 10)
        }
        .task {
            Task {
                self.status = viewModel.relationship?.status
                self.isConsidered = viewModel.relationship?.isConsidered
                
                pathManager.isTabBarHidden = true
            }
        }
        .onDisappear {
            pathManager.isTabBarHidden = false
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    MyPageEditRelationshipView(pathManager: .constant(OTAppPathManager()), viewModel: .constant(MyPageEditViewModel()))
}
