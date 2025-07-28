//
//  OTRouter.swift
//  OneThing
//
//  Created by 오현식 on 7/15/25.
//

import Foundation

/// 코디네이터가 준수해야 하는 프로토콜입니다.
/// 화면 네비게이션 로직(push, pop, sheet 등)과 자식 코디네이터 관리를 위한 인터페이스를 정의합니다.
protocol OTCoordinatorable: AnyObject, Identifiable {
    
    /// 코디네이터가 생성할 뷰를 정의하는 빌더 타입입니다.
    /// OTViewBuildable 프로토콜을 준수해야 합니다.
    associatedtype RootViewBuilder: OTViewBuildable
    
    /// 코디네이터의 고유 식별자입니다.
    var id: String { get }
    /// 네비게이션 스택을 관리하는 경로 배열입니다.
    /// SwiftUI의 `NavigationStack`과 연동됩니다.
    var path: [OTPath] { get set }
    /// 현재 표시된 시트(sheet)를 관리하는 경로입니다. nil이 아니면 시트가 표시됩니다.
    var sheet: OTPath? { get set }
    
    /// 코디네이터의 루트 뷰를 생성하는 빌더입니다.
    var rootViewBuilder: RootViewBuilder { get }
    /// 자식 코디네이터들을 관리하는 배열입니다.
    var childCoordinator: [any OTCoordinatorable] { get set }
    
    /// 새로운 뷰를 네비게이션 스택에 푸시합니다.
    func push(to path: OTPath)
    /// 네비게이션 스택에서 현재 뷰를 팝합니다.
    func pop()
    /// 지정된 경로까지 네비게이션 스택에서 뷰를 팝합니다.
    func pop(to path: OTPath)
    /// 네비게이션 스택의 모든 뷰를 팝하고 루트 뷰로 돌아갑니다.
    func popToRoot()
    /// 지정된 경로의 뷰를 시트로 표시합니다.
    func showSheet(to path: OTPath)
    /// 현재 표시된 시트를 닫습니다.
    func dismissSheet()
    
    /// 자식 코디네이터를 추가합니다.
    func addChild(_ coordinator: any OTCoordinatorable)
    /// 자식 코디네이터를 제거합니다.
    func removeChild(_ coordinator: any OTCoordinatorable)
}

/// `OTCoordinatorable` 프로토콜을 구현하는 기본 코디네이터 클래스입니다.
class OTBaseCoordinator<RootBuilder: OTViewBuildable>: OTCoordinatorable {
    
    /// 코디네이터 인스턴스를 문자열로 변환하여 고유 ID로 사용합니다.
    var id: String { String(describing: self) }
    /// 네비게이션 스택 경로를 저장하는 배열입니다.
    var path: [OTPath]
    /// 표시할 시트 경로를 저장하는 옵셔널 변수입니다.
    var sheet: OTPath?
    
    /// 루트 뷰를 생성하기 위한 빌더입니다.
    let rootViewBuilder: RootBuilder
    /// 자식 코디네이터들을 저장하는 배열입니다.
    var childCoordinator: [any OTCoordinatorable]
    
    /// 코디네이터를 초기화합니다.
    /// - Parameter rootViewBuilder: 이 코디네이터가 관리할 루트 뷰를 생성하는 빌더 객체입니다.
    init(rootViewBuilder: RootBuilder) {
        self.path = []
        self.rootViewBuilder = rootViewBuilder
        self.childCoordinator = []
    }
    
    /// `path` 배열에 새로운 경로를 추가하여 뷰를 푸시합니다.
    func push(to path: OTPath) {
        self.path.append(path)
    }
    /// `path` 배열에서 마지막 요소를 제거하여 뷰를 팝합니다.
    func pop() {
        guard self.path.isEmpty == false else { return }
        self.path.removeLast()
    }
    /// `path` 배열에서 특정 경로를 찾아, 그 이후의 모든 경로를 제거합니다.
    func pop(to path: OTPath) {
        // `path` 배열에서 전달받은 `path`와 일치하는 첫 번째 인덱스를 찾습니다.
        guard let targetIndex = self.path.firstIndex(of: path) else { return }
        // 예: path가 [A, B, C, D]이고 target이 B(index 1)이면, C, D를 지워야 함.
        // 지워야 할 개수 = 전체 개수 - (타겟 인덱스 + 1) = 4 - (1 + 1) = 2개.
        // 하지만 removeLast(_ k: Int)는 마지막 k개의 요소를 제거하므로,
        // (전체 개수 - 1) - 타겟 인덱스 = 3 - 1 = 2개를 제거하면 됩니다.
        self.path.removeLast(self.path.count - 1 - targetIndex)
    }
    /// `path` 배열의 모든 요소를 제거하여 루트 뷰로 돌아갑니다.
    func popToRoot() {
        self.path.removeAll()
    }
    /// `sheet` 프로퍼티에 경로를 할당하여 시트를 표시합니다.
    func showSheet(to path: OTPath) {
        self.sheet = path
    }
    /// `sheet` 프로퍼티를 `nil`로 설정하여 시트를 닫습니다.
    func dismissSheet() {
        self.sheet = nil
    }
    
    /// `childCoordinator` 배열에 자식 코디네이터를 추가합니다.
    func addChild(_ coordinator: any OTCoordinatorable) {
        self.childCoordinator.append(coordinator)
    }
    /// `childCoordinator` 배열에서 ID가 일치하는 자식 코디네이터를 제거합니다.
    func removeChild(_ coordinator: any OTCoordinatorable) {
        self.childCoordinator.removeAll(where: { $0.id == coordinator.id })
    }
}
