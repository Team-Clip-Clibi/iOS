//
//  SignUpMainView.swift
//  OneThing
//
//  Created by 윤동주 on 3/23/25.
//

import SwiftUI

import SDWebImageSwiftUI

struct SignUpMainView: View {
    
    @Environment(\.appCoordinator) var appCoordinator
    @Environment(\.signUpCoordinator) var signUpCoordinator
    
    @Binding var store: SignUpStore
    
    @State private var currentPage = 0
    
    var body: some View {
        
        @Bindable var signUpCoordinator = self.signUpCoordinator
        
        NavigationStack(path: $signUpCoordinator.path) {
            
            OTBaseView(String(describing: Self.self)) {
                
                VStack(alignment: .leading) {
                    // 상단 타이틀
                    VStack(alignment: .leading, spacing: 4) {
                        Text("오늘 대화 주제 딱 하나!")
                            .otFont(.heading2)
                            .foregroundStyle(.gray800)
                        Text("대화하고 싶은 주제에 맞는 분들끼리 만나요.")
                            .otFont(.subtitle2)
                            .foregroundStyle(.gray600)
                    }
                    .padding(.top, 40)
                    .padding(.horizontal, 16)
                    
                    VStack {
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 16) {
                                ForEach(
                                    0..<self.store.state.banners.count,
                                    id: \.self
                                ) { index in
                                    
                                    let banner = self.store.state.banners[index]
                                    BannerView(banner: banner)
                                        .tag(index)
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .contentMargins(.horizontal, 16, for: .scrollContent)
                        .scrollTargetBehavior(.viewAligned)
                        .scrollPosition(id: Binding($currentPage))
                        
                        HStack(spacing: 8) {
                            ForEach(0..<self.store.state.banners.count, id: \.self) { index in
                                Capsule()
                                    .fill(index == currentPage ? Color.purple300 : Color.gray300)
                                    .frame(width: index == currentPage ? 16 : 10, height: 10)
                                    .animation(.easeInOut(duration: 0.2), value: currentPage)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(height: 422)
                    
                    Spacer()
                    
                    VStack(spacing: 8) {
                        SocialLoginButton(type: .kakao, text: "Kakao로 로그인하기") {
                            Task {
                                await self.store.send(.loginWithKakao)
                            }
                        }
                        .onChange(of: self.store.state.loginResultByKakao) { _, new in
                            switch new {
                            case .success:
                                let appStateManager = self.appCoordinator.dependencies.rootContainer.resolve(AppStateManager.self)
                                appStateManager.isSignedIn = true
                                
                                self.appCoordinator.currentState = .mainTabBar
                            case .needToSignUp:
                                self.signUpCoordinator.push(to: .auth(.signUpTerm))
                            default:
                                LoggingManager.error("Error occurred while logging in with Kakao")
                            }
                        }
                        
                        SocialLoginButton(type: .apple, text: "Apple로 로그인하기") {
                            // apple login logic
                        }
                        
                        Button {
                            
                        } label: {
                            Text("원띵 미리보기")
                                .otFont(.body1)
                                .foregroundStyle(.gray600)
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 16)
                }
                .navigationDestination(for: OTPath.self) { path in
                    self.signUpCoordinator.destinationView(to: path)
                }
            }
        }
        .taskForOnce {
            await self.store.send(.banners)
        }
    }
}

extension SignUpMainView {
    struct BannerView: View {
        var banner: LoginBannerInfo
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.purple100)
                
                VStack(spacing: 32) {
                    WebImage(url: URL(string: self.banner.imagePresignedUrl))
                        .resizable()
                        .scaledToFit()
                        .frame(height: 210)
                    
                    Text(self.banner.text)
                        .otFont(.title1)
                        .foregroundStyle(.gray800)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(height: 400)
            .containerRelativeFrame(.horizontal)
        }
    }
    
    struct SocialLoginButton: View {
        enum LoginType {
            case kakao
            case apple
        }

        let type: LoginType
        let text: String
        let action: () -> Void

        var body: some View {
            Button(action: action) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(backgroundColor)
                        .frame(height: 48)
                    HStack {
                        Image(iconName)
                        Text(text)
                            .otFont(.body2)
                            .foregroundStyle(textColor)
                    }
                }
            }
        }

        private var backgroundColor: Color {
            switch type {
            case .kakao:
                return Color(hex: "FAE300")
            case .apple:
                return Color(hex: "000000")
            }
        }

        private var textColor: Color {
            switch type {
            case .kakao:
                return Color(hex: "2D2D2D")
            case .apple:
                return Color(hex: "FFFFFF")
            }
        }

        private var iconName: String {
            switch type {
            case .kakao: return "kakao"
            case .apple: return "apple"
            }
        }
    }
}

#Preview {
    let signUpStoreForPreview = SignUpStore(
        socialLoginUseCase: SocialLoginUseCase(),
        updateUserNameUseCase: UpdateUserNameUseCase(),
        updateNicknameUseCase: UpdateNicknameUseCase(),
        updatePhoneNumberUseCase: UpdatePhoneNumberUseCase(),
        getNicknameAvailableUseCase: GetNicknameAvailableUseCase(),
        getBannerUseCase: GetBannerUseCase()
    )
    SignUpMainView(store: .constant(signUpStoreForPreview))
}
