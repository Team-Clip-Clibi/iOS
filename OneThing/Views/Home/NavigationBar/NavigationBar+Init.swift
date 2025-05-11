//
//  NavigationBar+Init.swift
//  OneThing
//
//  Created by 오현식 on 5/9/25.
//

import SwiftUI

extension NavigationBar {
    /// 타이틀 설정
    func title(_ title: String) -> NavigationBar {
        var naviBar = self
        naviBar.title = title
        return naviBar
    }
    /// 타이틀 정렬 방식 설정
    func titleAlignment(_ alignment: TitleAlignment) -> NavigationBar {
        var naviBar = self
        naviBar.titleAlignment = alignment
        return naviBar
    }
    /// 커스텀 타이틀 뷰 설정
    func titleView<Content: View>(_ view: Content) -> NavigationBar {
        var naviBar = self
        naviBar.titleView = AnyView(view)
        return naviBar
    }
    /// 뒤로 가기 버튼 숨김 여부 설정
    func hidesBackButton(_ hide: Bool) -> NavigationBar {
        var naviBar = self
        naviBar.hidesBackButton = hide
        return naviBar
    }
    /// 뒤로 가기 버튼 액션 설정
    func onBackButtonTap(_ action: @escaping () -> Void) -> NavigationBar {
        var naviBar = self
        naviBar.onBackButtonTap = action
        return naviBar
    }
    /// 내부 여백 설정
    func inset(_ inset: EdgeInsets) -> NavigationBar {
        var naviBar = self
        naviBar.inset = inset
        return naviBar
    }
    /// 내부 요소들 사이의 간격 설정
    func spacing(_ spacing: CGFloat) -> NavigationBar {
        var naviBar = self
        naviBar.spacing = spacing
        return naviBar
    }
    /// 좌측 버튼 설정
    func leftButtons<Content: View>(_ buttons: [Content]) -> NavigationBar {
        var naviBar = self
        naviBar.leftButtons = buttons.map { AnyView($0) }
        return naviBar
    }
    /// 우측 버튼 설정
    func rightButtons<Content: View>(_ buttons: [Content]) -> NavigationBar {
        var naviBar = self
        naviBar.rightButtons = buttons.map { AnyView($0) }
        return naviBar
    }
}
