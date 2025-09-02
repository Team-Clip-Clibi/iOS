//
//  SignUpMoreInformationView.swift
//  OneThing
//
//  Created by 윤동주 on 4/6/25.
//

import SwiftUI

struct SignUpMoreInformationView: View {
    
    @Environment(\.appCoordinator) var appCoordinator
    @Environment(\.signUpCoordinator) var signUpCoordinator
    
    @Binding var store: SignUpStore
    
    @State var gender: Gender = .none
    @State var year: String = "YYYY"
    @State var month: String = "MM"
    @State var day: String = "DD"
    @State var city: City?
    var cityText: String {
        city?.rawValue ?? "시"
    }
    
    @State var county: County?
    var countyText: String {
        county?.name ?? "군/구"
    }
    
    @State var selectedCategory: InformationCategory? = nil
    
    @State private var showingSheet = false
    
    private var canClickedNext: Bool {
        gender != .none && year != "YYYY" && month != "MM" && day != "DD" && cityText != "시" && countyText != "군/구"
    }
    
    private var dateToString: String {
        "\(year)-\(month)-\(day)"
    }
    
    var body: some View {
        
        OTBaseView(String(describing: Self.self)) {
            
            VStack {
                
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("가입 후에도 언제든지 변경할 수 있어요.")
                                .otFont(.subtitle2)
                                .fontWeight(.semibold)
                                .foregroundStyle(.gray600)
                            Text("당신에 대해 조금 더\n알려주세요!")
                                .otFont(.heading2)
                                .fontWeight(.bold)
                                .foregroundStyle(.gray800)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                
                        }
                        Spacer()
                    }
                    .padding(.top, 32)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("성별")
                            .otFont(.body1)
                            .fontWeight(.medium)
                            .foregroundStyle(.gray800)
                        
                        OTXLButton(
                            buttonTitle: "남성",
                            action: { gender = .male },
                            isClicked: gender == .male
                        )
                        
                        OTXLButton(
                            buttonTitle: "여성",
                            action: { gender = .female },
                            isClicked: gender == .female
                        )
                    }
                    .padding(.top, 32)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("생년월일")
                            .otFont(.body1)
                            .fontWeight(.medium)
                            .foregroundStyle(.gray800)
                        HStack(spacing: 10) {
                            // 연도 버튼
                            OTXLButton(
                                buttonTitle: year,
                                isDropDownButton: true,
                                action: {
                                    self.selectedCategory = .year
                                    self.showingSheet = true
                                },
                                isClicked: false
                            )
                            // 월 버튼
                            OTXLButton(
                                buttonTitle: month,
                                isDropDownButton: true,
                                action: {
                                    self.selectedCategory = .month
                                    self.showingSheet = true
                                },
                                isClicked: false
                            )
                            // 일 버튼
                            OTXLButton(
                                buttonTitle: day,
                                isDropDownButton: true,
                                action: {
                                    self.selectedCategory = .day
                                    self.showingSheet = true
                                },
                                isClicked: false
                            )
                        }
                    }
                    .padding(.top, 24)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("활동 지역")
                            .otFont(.body1)
                            .fontWeight(.medium)
                            .foregroundStyle(.gray800)
                        HStack(spacing: 10) {
                            // 도시 버튼
                            OTXLButton(
                                buttonTitle: cityText,
                                isDropDownButton: true,
                                action: {
                                    self.selectedCategory = .city
                                    self.showingSheet = true
                                },
                                isClicked: false
                            )
                            // 군/구 버튼
                            // county 버튼은 도시가 선택되었을 때만 활성화되도록 처리할 수 있음.
                            OTXLButton(
                                buttonTitle: countyText,
                                isDropDownButton: true,
                                action: {
                                    // 만약 도시가 제대로 선택되지 않았다면 아무 동작도 하지 않음.
                                    if City(rawValue: cityText) != nil {
                                        self.selectedCategory = .county
                                        self.showingSheet = true
                                    }
                                },
                                isClicked: false
                            )
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
                            await self.store.send(
                                .updateDetail(
                                    gender: self.gender.rawValue,
                                    birth: self.dateToString,
                                    city: self.city,
                                    county: self.county
                                )
                            )
                        }
                    },
                    isClickable: canClickedNext
                )
                .padding(.horizontal, 17)
                .onChange(of: self.store.state.isDetailUpdated) { _, new in
                    if new {
                        let appStateManager = self.signUpCoordinator.dependencies.rootContainer.resolve(AppStateManager.self)
                        appStateManager.isSignedIn = true
                        
                        self.appCoordinator.currentState = .mainTabBar
                    }
                }
            }
            .sheet(item: $selectedCategory) { category in
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Button {
                            selectedCategory = nil // 닫기
                        } label: {
                            Image(.closeOutlined)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.black)
                        }
                        .padding(.vertical, 12)
                    }
                    .padding(.horizontal, 12)
                    .padding(.top, 24)
                    
                    ScrollView {
                        SignUpMoreInformationSheetView(
                            result: binding(for: category),
                            category: category,
                            selectedCity: category == .county ? city : nil
                        )
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                    }
                }
                .ignoresSafeArea(.container, edges: .bottom)
                .presentationDetents([.medium])
                .presentationDragIndicator(.hidden)
                .presentationCornerRadius(24)
            }
        }
        .navigationBar(
            title: "회원가입",
            hidesBottomSeparator: false,
            onBackButtonTap: {
                self.signUpCoordinator.pop()
            }
        )
    }
    
    // Helper: 선택한 카테고리에 해당하는 바인딩 반환
    private func binding(for category: InformationCategory) -> Binding<String> {
        switch category {
        case .year:
            return $year
        case .month:
            return $month
        case .day:
            return $day
        case .city:
            return Binding<String>(
                get: { self.city?.rawValue ?? "시" },
                set: { newValue in
                    self.city = City(rawValue: newValue)
                }
            )
        case .county:
            return Binding<String>(
                get: { self.county?.name ?? "군/구" },
                set: { newValue in
                    // 선택된 도시가 있어야 county 목록에서 값을 찾을 수 있음.
                    if let selectedCity = self.city {
                        self.county = selectedCity.counties.first(where: { $0.name == newValue })
                    }
                }
            )
        }
    }
}

extension SignUpMoreInformationView.InformationCategory: Identifiable {
    var id: String { rawValue }
}

extension SignUpMoreInformationView {
    // 열거형으로 각 정보 카테고리 정의
    enum InformationCategory: String, CaseIterable {
        case year, month, day, city, county
    }
    
    // 각 카테고리에 따른 sheet 뷰
    struct SignUpMoreInformationSheetView: View {
        @Environment(\.dismiss) private var dismiss
        
        @Binding var result: String
        
        var category: InformationCategory
        // county 선택 시, 해당 도시의 county 목록을 전달받음 (기본값은 nil)
        var selectedCity: City? = nil
        
        var body: some View {
            switch category {
            case .year:
                LazyVStack(spacing: 10) {
                    ForEach((1900...2025).reversed(), id: \.self) { year in
                        OTLButton(
                            buttonTitle: String(year),
                            action: {
                                self.result = String(year)
                                dismiss()
                            },
                            isClicked: false
                        )
                        .padding(.top, 10)
                    }
                }
            case .month:
                LazyVStack(spacing: 10) {
                    ForEach(1...12, id: \.self) { month in
                        let monthString = String(format: "%02d", month)
                        OTLButton(
                            buttonTitle: monthString,
                            action: {
                                self.result = monthString
                                dismiss()
                            },
                            isClicked: false
                        )
                        .padding(.top, 10)
                    }
                }
            case .day:
                LazyVStack(spacing: 10) {
                    ForEach(1...31, id: \.self) { day in
                        let dayString = String(format: "%02d", day)
                        OTLButton(
                            buttonTitle: dayString,
                            action: {
                                self.result = dayString
                                dismiss()
                            },
                            isClicked: false
                        )
                        .padding(.top, 10)
                    }
                }
            case .city:
                LazyVStack(spacing: 10) {
                    ForEach(City.allCases, id: \.self) { city in
                        OTLButton(
                            buttonTitle: city.rawValue,
                            action: {
                                self.result = city.rawValue
                                dismiss()
                            },
                            isClicked: false
                        )
                        .padding(.top, 10)
                    }
                }
            case .county:
                if let city = selectedCity {
                    LazyVStack(spacing: 10) {
                        ForEach(city.counties, id: \.code) { county in
                            OTLButton(
                                buttonTitle: county.name,
                                action: {
                                    self.result = county.name
                                    dismiss()
                                },
                                isClicked: false
                            )
                            .padding(.top, 10)
                        }
                    }
                }
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
    SignUpMoreInformationView(store: .constant(signUpStoreForPreview))
}
