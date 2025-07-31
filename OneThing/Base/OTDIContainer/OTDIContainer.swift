//
//  OTDIContainer.swift
//  OneThing
//
//  Created by 오현식 on 7/29/25.
//

import Foundation

/// DI 컨테이너가 수행해야 할 기능을 정의하는 프로토콜입니다.
/// `register`: 의존성을 등록합니다.
/// `resolve`: 등록된 의존성을 반환합니다.
protocol OTDIContainerable {
    
    /// 서비스 타입과 해당 서비스를 생성하는 클로저(factory)를 등록합니다.
    /// - Parameters:
    ///   - type: 등록할 서비스의 프로토콜 타입입니다.
    ///   - factory: 서비스를 생성하는 클로저입니다. 이 클로저는 자기 자신(컨테이너)을 파라미터로 받아,
    ///              다른 의존성을 해결(resolve)하는 데 사용할 수 있습니다.
    func register<Service>(_ type: Service.Type, factory: @escaping (OTDIContainerable) -> Service)

    /// 등록된 서비스 타입의 인스턴스를 반환합니다.
    /// - Parameter type: 해결(resolve)하려는 서비스의 프로토콜 타입입니다.
    /// - Returns: 등록된 서비스의 인스턴스를 반환합니다. 만약 등록되지 않았다면 앱이 강제 종료됩니다. (개발 단계에서 의존성 설정 오류를 빠르게 파악하기 위함)
    func resolve<Service>(_ type: Service.Type) -> Service
}

/// `OTDIContainerable`의 실제 구현 클래스입니다.
final class OTDIContainer: OTDIContainerable {
    
    // 등록된 서비스의 생성 클로저(factory)를 저장하는 딕셔너리입니다.
    // 키는 서비스 타입의 이름(String), 값은 Any를 반환하는 클로저입니다.
    private var factories: [String: (OTDIContainerable) -> Any] = [:]
    
    func register<Service>(_ type: Service.Type, factory: @escaping (OTDIContainerable) -> Service) {
        let key = String(describing: type)
        self.factories[key] = factory
    }
    
    func resolve<Service>(_ type: Service.Type) -> Service {
        let key = String(describing: type)
        guard let factory = self.factories[key] else {
            // 해당 의존성이 등록되지 않은 경우, 개발자가 실수를 바로 인지할 수 있도록 fatalError를 발생시킵니다.
            fatalError("Dependency for \(key) not registered.")
        }
        
        // factory는 (DIContainerProtocol) -> Any 타입을 가지므로,
        // 실제 서비스 타입(Service)으로 캐스팅하여 반환합니다.
        // register 함수에서 타입을 보장하므로 강제 캐스팅(!)이 안전합니다.
        return factory(self) as! Service
    }
}
