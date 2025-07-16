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
    associatedtype Store: OTStore
    /// 이 빌더를 통해 생성될 SwiftUI 뷰의 타입입니다.
    associatedtype Content: View
    
    /// 이 빌더가 담당하는 고유한 네비게이션 경로(`OTPath`)입니다.
    /// 코디네이터는 이 `matchedPath` 값을 보고 어떤 빌더를 사용해야 할지 결정합니다.
    var matchedPath: OTPath { get }
    
    /// 주어진 스토어(`store`)를 사용하여 실제 SwiftUI 뷰(`Content`)를 생성하고 반환합니다.
    /// - Parameter store: 뷰와 데이터를 양방향으로 바인딩하기 위한 `Binding` 타입의 스토어입니다.
    /// - Returns: 상태가 주입된 SwiftUI 뷰를 반환합니다.
    func build(store: Binding<Store>) -> Content
}
