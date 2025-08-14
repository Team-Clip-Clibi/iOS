//
//  InitialMatchingSelectLanguageView.swift
//  OneThing
//
//  Created by 오현식 on 5/25/25.
//

import SwiftUI

struct InitialMatchingSelectLanguageView: View {
    
    enum Constants {
        enum Text {
            static let naviTitle = "모임 신청"
            
            static let title = "사용하는 언어를 선택해주세요"
            static let subTitle = "모임 진행을 위해 주로 사용하는 언어를 알려주세요"
            
            static let completeButtonTitle = "완료"
        }
        
        static let progress = 1.0
    }
    
    @Environment(\.homeCoordinator) var homeCoordinator
    
    @Binding var store: InitialMatchingStore
    
    @State private var isCompleteButtonEnabled: Bool = false
    @State private var selectedLanguages: [Language] = []
    
    var body: some View {
        
        OTBaseView(String(describing: Self.self)) {
            
            VStack {
                
                LinerProgressView(value: Constants.progress, shape: Rectangle())
                    .tint(.purple400)
                
                Spacer().frame(height: 32)
                
                GuideMessageView(
                    isChangeSubTitleColor: .constant(false),
                    title: Constants.Text.title,
                    subTitle: Constants.Text.subTitle
                )
                
                Spacer().frame(height: 24)
                
                MultipleOnlyTextBoxView<Language>(
                    state: .init(
                        items: Language.allCases.map { .init(item: $0) },
                        selectionLimit: 1,
                        changeWhenIsReachedLimit: true
                    ),
                    isReachedLimit: .constant(false),
                    isSelected: $isCompleteButtonEnabled,
                    selectedItems: $selectedLanguages,
                    cols: [GridItem()],
                    alignment: .leading
                )
                .onChange(of: self.selectedLanguages) { _, new in
                    guard let selectedLanguage = new.last else { return }
                    Task { await self.store.send(.updateSelectedLanguages(selectedLanguage)) }
                }
                
                Spacer()
                
                BottomButton(
                    isClickable: $isCompleteButtonEnabled,
                    title: Constants.Text.completeButtonTitle,
                    buttonTapAction: { Task { await self.store.send(.updateAll) } }
                )
            }
        }
        .navigationBar(
            title: Constants.Text.naviTitle,
            hidesBottomSeparator: true,
            onBackButtonTap: {
                Task { await self.store.send(.updateSelectedLanguages(nil)) }
                self.homeCoordinator.pop()
            }
        )
        .onChange(of: self.store.state.isUpdated) { _, new in
            if new {
                self.homeCoordinator.path.removeAll()
                var path: OTPath? {
                    switch self.homeCoordinator.willPushedMatchingType {
                    case .onething:
                        return .home(.onething(.main))
                    case .random:
                        return .home(.random(.main))
                    default:
                        return nil
                    }
                }
                
                guard let path = path else { return }
                
                self.homeCoordinator.push(to: path)
            }
        }
    }
}

#Preview {
    let initialMatchingStoreForPreview = InitialMatchingStore(
        willPushedMatchingType: .onething,
        updateJobUseCase: UpdateJobUseCase(),
        updateDietaryUseCase: UpdateDietaryUseCase(),
        updateLanguageUseCase: UpdateLanguageUseCase()
    )
    InitialMatchingSelectLanguageView(store: .constant(initialMatchingStoreForPreview))
}
