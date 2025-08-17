//
//  MyPageCoordinator.swift
//  OneThing
//
//  Created by 오현식 on 8/10/25.
//

import SwiftUI

@Observable
final class MyPageCoordinator: OTBaseCoordinator {

    private var myPageEditStore: MyPageEditStore
    private var myPageEditStoreForBinding: Binding<MyPageEditStore> {
        Binding(
            get: { self.myPageEditStore },
            set: { self.myPageEditStore = $0 }
        )
    }
    
    private var myPageNotificationStore: MyPageNotificationStore
    private var myPageNotificationStoreForBinding: Binding<MyPageNotificationStore> {
        Binding(
            get: { self.myPageNotificationStore },
            set: { self.myPageNotificationStore = $0 }
        )
    }
    
    private var myPageReportStore: MyPageReportStore
    private var myPageReportStoreForBinding: Binding<MyPageReportStore> {
        Binding(
            get: { self.myPageReportStore },
            set: { self.myPageReportStore = $0 }
        )
    }
    
    var dependencies: AppDIContainer
    
    init(dependencies: AppDIContainer) {
        self.dependencies = dependencies
        
        let myPageEditStore = dependencies.setupMyPageEditContainer().resolve(MyPageEditStore.self)
        self.myPageEditStore = myPageEditStore
        
        let myPageNotificationStore = dependencies.setupMyPageNotificationContainer().resolve(
            MyPageNotificationStore.self
        )
        self.myPageNotificationStore = myPageNotificationStore
        
        let myPageReportStore = dependencies.setupMyPageReportContainer().resolve(MyPageReportStore.self)
        self.myPageReportStore = myPageReportStore
        
        super.init(rootViewBuilder: MyPageViewBuilder())
    }
    
    func start() -> MyPageView {
        return (self.rootViewBuilder as! MyPageViewBuilder).build(store: self.myPageEditStoreForBinding)
    }
    
    @ViewBuilder
    func destinationEditView(to path: OTPath) -> some View {
        switch path {
        case .myPage(.editJob):
            MyPageEditJobViewBuilder().build(store: self.myPageEditStoreForBinding)
        case .myPage(.editLanguage):
            MyPageEditLanguageViewBuilder().build(store: self.myPageEditStoreForBinding)
        case .myPage(.editNickName):
            MyPageEditNicknameViewBuilder().build(store: self.myPageEditStoreForBinding)
        case .myPage(.editDiet):
            MyPageEditDietaryViewBuilder().build(store: self.myPageEditStoreForBinding)
        case .myPage(.editRelationship):
            MyPageEditRelationshipViewBuilder().build(store: self.myPageEditStoreForBinding)
            
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    func destinationView(to path: OTPath) -> some View {
        switch path {
        case .myPage(.editProfile):
            MyPageEditProfileViewBuilder().build(store: self.myPageEditStoreForBinding)
            
        case .myPage(.notification):
            MyPageNotificationViewBuilder().build(store: self.myPageNotificationStoreForBinding)
            
        case .myPage(.report):
            MyPageReportMainViewBuilder().build(store: self.myPageReportStoreForBinding)
        case .myPage(.reportReason):
            MyPageReportReasonViewBuilder().build(store: self.myPageReportStoreForBinding)
        case .myPage(.reportMatching):
            MyPageReportMatchingViewBuilder().build(store: self.myPageReportStoreForBinding)
            
        default:
            EmptyView()
        }
    }
}

private struct MyPageCoordinatorKey: EnvironmentKey {
    // static var defaultValue: AppCoordinator {
    //     fatalError("FatalError: AppCoordinator not set in environment")
    // }
    static var defaultValue: MyPageCoordinator = MyPageCoordinator(dependencies: AppDIContainer())
}

extension EnvironmentValues {
    var myPageCoordinator: MyPageCoordinator {
        get { self[MyPageCoordinatorKey.self] }
        set { self[MyPageCoordinatorKey.self] = newValue }
    }
}
