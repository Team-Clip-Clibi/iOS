//
//  OTViewBuilder.swift
//  OneThing
//
//  Created by 오현식 on 7/15/25.
//

import SwiftUI

/// SwiftUI 뷰(`View`)를 생성하는 객체가 준수해야 하는 프로토콜입니다.
/// 특정 경로(`OTPath`)에 해당하는 뷰를 어떻게 만들지 정의합니다.
protocol OTViewBuildable {
    /// 뷰의 상태(State)를 관리하는 스토어(Store)의 타입입니다.
    /// `OTStore` 프로토콜을 준수해야 합니다.
    associatedtype Store: OTStore = EmptyStore
    /// 이 빌더를 통해 생성될 SwiftUI 뷰의 타입입니다.
    associatedtype Content: View
    
    /// 이 빌더가 담당하는 고유한 네비게이션 경로(`OTPath`)입니다.
    /// 코디네이터는 이 `matchedPath` 값을 보고 어떤 빌더를 사용해야 할지 결정합니다.
    var matchedPath: OTPath { get }
    
    /// 주어진 스토어(`store`)를 사용하여 실제 SwiftUI 뷰(`Content`)를 생성하고 반환합니다.
    /// - Parameter store: 뷰와 데이터를 양방향으로 바인딩하기 위한 `Binding` 타입의 스토어입니다.
    /// - Returns: 상태가 주입된 SwiftUI 뷰를 반환합니다.
    func build(store: Binding<Store>) -> Content
    
    /// 주어진 스토어(`store`)가 EmptyStore일 때, 실제 SwiftUI 뷰(`Content`)를 생성하고 반환합니다.
    func build() -> Content
}

extension OTViewBuildable {
    
    /// **상태가 있는 뷰 빌더를 위한 기본 구현**
    /// `build()`가 호출되면 `build(store:)`를 구현하도록 유도하며 런타임 에러를 발생시킵니다.
    /// 따라서 상태가 있는 뷰 빌더는 이 메서드를 신경 쓸 필요가 없습니다.
    func build() -> Content {
        fatalError("\(type(of: self))는 Store가 필요한 빌더입니다. build(store:) 메서드를 구현하고 호출해야 합니다.")
    }
    
    /// **상태가 없는 뷰 빌더를 위한 기본 구현**
    /// `Store` 타입이 기본값인 `EmptyStore`일 때, `build(store:)`가 호출되면
    /// 자동으로 `build()` 메서드를 대신 호출해 줍니다.
    func build(store: Binding<Store>) -> Content {
        guard store.wrappedValue is EmptyStore else {
            fatalError("\(type(of: self))는 build(store:) 메서드를 직접 구현해야 합니다.")
        }
        // Store가 EmptyStore이므로, store 파라미터 없이 build()를 호출
        return build()
    }
}
