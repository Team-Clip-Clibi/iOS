//
//  MyPageEditProfileView.swift
//  OneThing
//
//  Created by 윤동주 on 4/13/25.
//

import SwiftUI
import PopupView

struct MyPageEditProfileView: View {
    
    @Environment(\.appCoordinator) var appCoordinator
    @Environment(\.myPageCoordinator) var myPageCoordinator
    
    @Binding var store: MyPageEditStore
    
    @State var isWithdrawPopUpVisible: Bool = false
    @State var isSignOutPopUpVisible: Bool = false
    
    var body: some View {
        
        OTBaseView(String(describing: Self.self)) {
            
            ZStack {
                VStack {
                    
                    ScrollView {
                        // MARK: - 기본 정보 섹션
                        LazyVStack {
                            HStack {
                                Text("기본 정보")
                                    .otFont(.caption1)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.gray600)
                                Spacer()
                            }
                            InfoRow(title: "이름", value: self.store.state.profileInfo?.username ?? "")
                            InfoRow(title: "소셜 로그인", value: self.store.state.profileInfo?.platform ?? "")
                            InfoRow(title: "전화번호", value: self.store.state.profileInfo?.phoneNumber ?? "")
                            InfoRow(title: "닉네임", value: self.store.state.profileInfo?.nickname ?? "", isClickable: true) {
                                self.myPageCoordinator.push(to: .myPage(.editNickName))
                            }
                        }
                        .background(Color.white)
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                        
                        Rectangle()
                            .frame(maxWidth: .infinity, maxHeight: 8)
                            .foregroundStyle(.gray200)
                        
                        // MARK: - 나의 모임 정보 섹션
                        VStack {
                            HStack {
                                Text("나의 정보")
                                    .otFont(.caption1)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.gray600)
                                Spacer()
                            }
                            InfoRow(title: "하는 일", value: self.store.state.job?.toKorean ?? "", isClickable: true, action: {
                                self.myPageCoordinator.push(to: .myPage(.editJob))
                            })
                            InfoRow(title: "연애 상태", value: self.store.state.relationship?.status?.toKorean ?? "", isClickable: true, action: {
                                self.myPageCoordinator.push(to: .myPage(.editRelationship))
                            })
                            InfoRow(title: "식단 제한", value: self.store.state.dietary, isClickable: true, action: {
                                self.myPageCoordinator.push(to: .myPage(.editDiet))
                            })
                            InfoRow(title: "사용 언어", value: self.store.state.language?.toKorean ?? "", isClickable: true, action: {
                                self.myPageCoordinator.push(to: .myPage(.editLanguage))
                            })
                        }
                        .background(Color.white)
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                        
                        Rectangle()
                            .frame(maxWidth: .infinity, maxHeight: 8)
                            .foregroundStyle(.gray200)
                        
                        // MARK: - 계정 관리 섹션
                        VStack {
                            HStack {
                                Text("계정 관리")
                                    .otFont(.caption1)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.gray600)
                                Spacer()
                            }
                            InfoRow(title: "로그아웃", value: "", isClickable: true, action: {
                                self.isSignOutPopUpVisible = true
                            })
                            InfoRow(title: "회원탈퇴", value: "", isClickable: true, action: {
                                self.isWithdrawPopUpVisible = true
                            })
                        }
                        .background(Color.white)
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                        
                        Spacer()
                    }
                }
                
                if isWithdrawPopUpVisible {
                    ZStack {
                        Color.black.opacity(0.4)
                            .transition(.opacity)
                            .onTapGesture { isWithdrawPopUpVisible = false
                            }
                        
                        OTAlertView(
                            title: "정말 원띵을 떠나실건가요",
                            subTitle: "계정이 삭제되면 모든 데이터가 영구 삭제됩니다.",
                            firstButton: "탈퇴하기",
                            secondButton: "취소",
                            firstAction: {
                                Task {
                                    await self.store.send(.deleteAccount)
                                }
                            },
                            secondAction: {
                                isWithdrawPopUpVisible = false
                            }
                        )
                    }
                    .ignoresSafeArea()
                    .onChange(of: self.store.state.isAccountDeleted) { _, newValue in
                        self.myPageCoordinator.pop()
                    }
                }
                
                if isSignOutPopUpVisible {
                    ZStack {
                        Color.black.opacity(0.4)
                            .transition(.opacity)
                            .onTapGesture {
                                isWithdrawPopUpVisible = false
                            }
                        
                        OTAlertView(
                            title: "로그아웃 하시겠어요?",
                            subTitle: "저장된 정보는 유지되며, 다시 로그인하면 이어서/n이용할 수 있습니다.",
                            firstButton: "로그아웃",
                            secondButton: "취소",
                            firstAction: {
                                Task {
                                    TokenManager.shared.accessToken = ""
                                    TokenManager.shared.refreshToken = ""
                                    
                                    let appStateManager = self.appCoordinator.dependencies.rootContainer.resolve(AppStateManager.self)
                                    appStateManager.isSignedIn = false
                                    
                                    self.appCoordinator.currentState = .signUp
                                }
                            },
                            secondAction: {
                                isSignOutPopUpVisible = false
                            }
                        )
                    }
                    .ignoresSafeArea()
                }
            }
            .taskForOnce {
                await self.store.send(.profile)
                await self.store.send(.job)
                await self.store.send(.relationship)
                await self.store.send(.dietary)
                await self.store.send(.language)
            }
        }
        .navigationBar(
            title: "프로필 수정",
            onBackButtonTap: {
                self.myPageCoordinator.pop()
            }
        )
    }
}

// MARK: - 단순 텍스트 정보 표시 행
struct InfoRow: View {
    let title: String
    var value: String
    var isClickable: Bool = false
    var action: (() -> Void)?
    
    var body: some View {
        Button{
            action?()
        } label: {
            HStack {
                Text(title)
                    .otFont(.body1)
                    .fontWeight(.medium)
                    .foregroundStyle(.gray800)
                Spacer()
                HStack {
                    if title == "소셜 로그인" {
                        value == "KAKAO" ? Image(.kakaoText) : Image(.appleFill)
                    }
                    Text(title == "소셜 로그인" ? value == "KAKAO" ? "카카오톡" : "애플" : value)
                        .otFont(.body1)
                        .fontWeight(.medium)
                        .foregroundStyle(.gray800)
                    if isClickable {
                        Image(.rightArrow)
                            .foregroundStyle(.gray400)
                    }
                }
            }
            .padding(.vertical, 14)
        }
        .disabled(!isClickable)
    }
}

// MARK: - 섹션 헤더 (예: "나의 모임 정보")
struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .otFont(.caption1)
            .foregroundColor(.gray)
    }
}

// MARK: - 네비게이션용 행 (오른쪽에 Chevron 아이콘)
struct NavigationRow: View {
    let title: String
    var action: () -> Void = {}
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(title)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let myPageEditStoreForPreview = MyPageEditStore(
        socialLoginUseCase: SocialLoginUseCase(),
        
        getProfileInfoUseCase: GetProfileInfoUseCase(),
        getJobUseCase: GetJobUseCase(),
        getRelationshipUseCase: GetRelationshipUseCase(),
        getDietaryUseCase: GetDietaryUseCase(),
        getLanguageUseCase: GetLanguageUseCase(),
        getNicknameAvailableUseCase: GetNicknameAvailableUseCase(),
        
        updateNicknameUseCase: UpdateNicknameUseCase(),
        updateJobUseCase: UpdateJobUseCase(),
        updateRelationshipUseCase: UpdateRelationshipUseCase(),
        updateDietaryUseCase: UpdateDietaryUseCase(),
        updateLanguageUseCase: UpdateLanguageUseCase()
    )
    MyPageEditProfileView(store: .constant(myPageEditStoreForPreview))
}
