//
//  SignUpMainView.swift
//  OneThing
//
//  Created by 윤동주 on 3/23/25.
//

import SwiftUI

struct SignUpMainView: View {
    
    @Binding var authPathManager: OTAuthPathManager
    @Environment(AppStateManager.self) var appStateManager
    
    @State private var viewModel = SignUpViewModel()
    @State private var currentPage = 0
    
    var body: some View {
        
        NavigationStack(path: $authPathManager.paths) {
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
                
                // Carousel
                TabView(selection: $currentPage) {
                    ForEach(0..<3, id: \.self) { index in
                        BannerView(banner: viewModel.banners[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 400)
                .padding(.top, 16)
                
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        Capsule()
                            .fill(index == currentPage ? Color.purple300 : Color.gray300)
                            .frame(width: index == currentPage ? 16 : 10, height: 10)
                            .animation(.easeInOut(duration: 0.2), value: currentPage)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 16)
                
                Spacer()
                
                VStack(spacing: 8) {
                    SocialLoginButton(type: .kakao, text: "Kakao로 로그인하기") {
                        Task {
                            let result = try await viewModel.loginWithKakao()
                            switch result {
                            case .success:
                                appStateManager.isSignedIn = true
                            case .needToSignUp:
                                authPathManager.push(path: .signUpTerm)
                            default:
                                print("로그인 에러발생")
                            }
                            
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
            }
            .padding(.horizontal, 17)
            .navigationDestination(for: OTAuthPath.self) { path in
                switch path {
                case .signUpTerm:
                    SignUpTermView(viewModel: $viewModel, authPathManager: $authPathManager)
                case .signUpPhoneNumber:
                    SignUpPhoneNumberView(authPathManager: $authPathManager, viewModel: $viewModel)
                case .signUpName:
                    SignUpNameView(authPathManager: $authPathManager, viewModel: $viewModel)
                case .signUpNickname:
                    SignUpNicknameView(authPathManager: $authPathManager, viewModel: $viewModel)
                case .signUpMoreInformation:
                    SignUpMoreInformationView(authPathManager: $authPathManager, viewModel: $viewModel)
                }
            }
        }
        .onAppear {
            Task {
//                try await self.viewModel.fetchBanner()
            }
        }
    }
}

extension SignUpMainView {
    struct BannerView: View {
        var banner: Banner
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.gray100)
                    .frame(width: 360, height: 400)
                
                VStack(spacing: 12) {
                    AsyncImage(url: URL(string: banner.imagePresignedUrl)!)
                        .background(.gray600)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 250, height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                    
                    // Text(banner.headText)
                    //     .otFont(.heading3)
                    //     .foregroundStyle(.gray800)
                    //
                    // Text(banner.subText)
                    //     .otFont(.subtitle2)
                    //     .foregroundStyle(.gray700)
                }
            }
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
    SignUpMainView(authPathManager: .constant(OTAuthPathManager()))
        .environment(AppStateManager())
}
