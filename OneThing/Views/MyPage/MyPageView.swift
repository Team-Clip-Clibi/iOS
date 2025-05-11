//
//  MyPageView.swift
//  OneThing
//
//  Created by 윤동주 on 4/13/25.
//

import SwiftUI

struct MyPageView: View {
    
    @Binding var pathManager: OTAppPathManager
    @Binding var viewModel: MyPageEditViewModel
    
    var body: some View {
        ZStack {
            Color.gray100
                .ignoresSafeArea()
            VStack(spacing:0) {
                VStack(spacing: 0) {
                    // 상단 타이틀 영역
                    HStack {
                        Text("마이")
                            .otFont(.title1)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding(.top, 10)
                    
                    // 프로필 정보 카드
                    VStack {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 6) {
                                Text("안녕하세요!")
                                    .otFont(.title1)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.purple400)
                                Text("\( viewModel.profileInfo?.username ?? "원띵")님")
                                    .otFont(.title1)
                                    .fontWeight(.semibold)
                                
                            }
                            Rectangle()
                                .fill(Color.gray200)
                                .frame(height: 1)
                            
                            Text("지금까지 총 N번 모임에 참여했어요!")
                                .otFont(.title1)
                                .fontWeight(.regular)
                            
                            OTLButton(
                                buttonTitle: "프로필 수정",
                                action: {
                                    self.pathManager.myPagePaths.append(.editProfile)
                                },
                                isClicked: false,
                                pressed: true
                            )
                            .padding(.top, 16)
                            .padding(.bottom, 10)
                        }
                        .padding(20)
                    }
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.top, 22)
                    VStack(spacing: 12) {
                        // 기타 버튼들
                        OTLButton(
                            buttonImage: Image("myPageBell"),
                            buttonTitle: "알림 설정",
                            backgroundColor: Color.white100,
                            borderColor: Color.white100,
                            action: {
                                pathManager.push(path: .notification)
                            },
                            isClicked: false
                        )
                        
                        OTLButton(
                            buttonImage: Image("myPageNotification"),
                            buttonTitle: "공지사항",
                            backgroundColor: Color.white100,
                            borderColor: Color.white100,
                            action: {
                                // 공지사항 액션
                            },
                            isClicked: false
                        )
                        
                        OTLButton(
                            buttonImage: Image("myPageCustomerService"),
                            buttonTitle: "고객센터",
                            backgroundColor: Color.white100,
                            borderColor: Color.white100,
                            action: {
                                // 고객센터 액션
                            },
                            isClicked: false
                        )
                        
                        OTLButton(
                            buttonImage: Image("myPageAlert"),
                            buttonTitle: "신고하기",
                            backgroundColor: Color.white100,
                            borderColor: Color.white100,
                            action: {
                                Task {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        pathManager.isTabBarHidden = true
                                    }
                                    
                                    try await Task.sleep(nanoseconds: 300_000_000)
                                    
                                    pathManager.push(path: .report)
                                }
                            },
                            isClicked: false
                        )
                    }
                    .padding(.top, 12)
                    
                    Spacer()
                    
                }
                .padding(.horizontal, 16)
                Rectangle()
                    .fill(Color.gray300)
                    .frame(height: 1)
                    .padding(.top, 12)
                
                HStack(spacing: 16) {
                    Button(action: {
                        pathManager.withTabBarHiddenThenNavigate {
                            pathManager.push(path: .term)
                        }
                    }) {
                        Text("약관 및 정책")
                            .otFont(.captionTwo)
                            .fontWeight(.medium)
                            .foregroundColor(Color.gray700)
                    }
                    
                    RoundedRectangle(cornerRadius: 90)
                        .frame(width: 2, height: 10)
                        .foregroundColor(Color.gray300)
                    
                    Button(action: {
                        
                    }) {
                        Text("원띵 이용 가이드")
                            .otFont(.captionTwo)
                            .fontWeight(.medium)
                            .foregroundColor(Color.gray700)
                    }
                    
                    Spacer()
                }
                .padding(.top, 13)
                .padding(.leading, 16)
                .padding(.bottom, 43)
            }
        }
        .onAppear {
            Task {
                _ = try await self.viewModel.fetchProfile()
                
            }
        }
    }
}

#Preview {
    MyPageView(
        pathManager: .constant(OTAppPathManager()),
        viewModel: .constant(MyPageEditViewModel())
    )
}
