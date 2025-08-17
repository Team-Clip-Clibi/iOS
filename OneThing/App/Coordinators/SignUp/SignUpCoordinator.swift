//
//  SignUpCoordinator.swift
//  OneThing
//
//  Created by 오현식 on 8/7/25.
//

import SwiftUI

@Observable
final class SignUpCoordinator: OTBaseCoordinator {

    private var signUpStore: SignUpStore
    private var signUpStoreForBinding: Binding<SignUpStore> {
        Binding(
            get: { self.signUpStore },
            set: { self.signUpStore = $0 }
        )
    }
    
    var dependencies: AppDIContainer
    
    init(dependencies: AppDIContainer) {
        self.dependencies = dependencies
        
        let signUpStore = dependencies.setupSignUpContainer().resolve(SignUpStore.self)
        self.signUpStore = signUpStore
        
        super.init(rootViewBuilder: SignUpMainViewBuilder())
    }
    
    func start() -> SignUpMainView {
        (self.rootViewBuilder as! SignUpMainViewBuilder).build(store: self.signUpStoreForBinding)
    }
    
    @ViewBuilder
    func destinationView(to path: OTPath) -> some View {
        switch path {
        case .auth(.signUpTerm):
            SignUpTermViewBuilder().build(store: self.signUpStoreForBinding)
        case .auth(.signUpPhoneNumber):
            SignUpPhoneNumberViewBuilder().build(store: self.signUpStoreForBinding)
        case .auth(.signUpName):
            SignUpNameViewBuilder().build(store: self.signUpStoreForBinding)
        case .auth(.signUpNickname):
            SignUpNicknameViewBuilder().build(store: self.signUpStoreForBinding)
        case .auth(.signUpMoreInformation):
            SignUpMoreInformationViewBuilder().build(store: self.signUpStoreForBinding)
        default:
            EmptyView()
        }
    }
}

private struct SignUpCoordinatorKey: EnvironmentKey {
    // static var defaultValue: AppCoordinator {
    //     fatalError("FatalError: AppCoordinator not set in environment")
    // }
    static var defaultValue: SignUpCoordinator = SignUpCoordinator(dependencies: AppDIContainer())
}

extension EnvironmentValues {
    var signUpCoordinator: SignUpCoordinator {
        get { self[SignUpCoordinatorKey.self] }
        set { self[SignUpCoordinatorKey.self] = newValue }
    }
}
