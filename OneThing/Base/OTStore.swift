//
//  OTStore.swift
//  OneThing
//
//  Created by 오현식 on 7/11/25.
//

import Foundation

/// 모든 상태(State) 타입이 준수해야 하는 프로토콜입니다.
/// 상태는 값 타입(struct)으로 정의되며, 변화를 감지하기 위해 Equatable을 준수해야 합니다.
protocol OTState: Equatable { }
/// 모든 액션(Action) 타입이 준수해야 하는 프로토콜입니다.
/// 액션은 뷰(View) 또는 외부에서 스토어(Store)로 전달되어 특정 이벤트를 나타냅니다.
protocol OTAction: Equatable { }
/// 모든 프로세스(Process) 타입이 준수해야 하는 프로토콜입니다.
/// 프로세스는 액션의 결과로 발생하며, 상태를 변경하기 위한 구체적인 정보를 담습니다.
/// ReactorKit의 Mutation과 유사한 역할을 합니다.
protocol OTProcess: Equatable { }

/// 'process' 함수가 반환할 수 있는 결과의 종류를 정의하는 열거형입니다.
/// 이 열거형을 통해 하나의 액션이 여러 프로세스를 유발할 수 있도록 유연성을 제공합니다.
enum OTProcessResult<ProcessType: OTProcess> {
    /// 단일 프로세스를 반환할 때 사용합니다.
    case single(ProcessType)
    /// 여러 프로세스를 순차적으로 반환할 때 사용합니다.
    /// 배열에 담긴 순서대로 프로세스가 처리됩니다.
    case concat([ProcessType])
    /// 반환할 프로세스가 없을 때 사용합니다.
    case none
}

/// 스토어(Store)는 상태를 관리하고, 액션을 처리하며, 프로세스를 통해 상태 변화를 조율합니다.
protocol OTStore: AnyObject {
    /// 스토어가 처리할 액션의 타입을 정의합니다.
    associatedtype ActionType: OTAction
    /// 스토어가 생성하고 리듀서(Reducer)에 전달할 프로세스의 타입을 정의합니다.
    associatedtype ProcessType: OTProcess
    /// 스토어가 관리할 상태의 타입을 정의합니다.
    associatedtype StateType: OTState
    
    /// 스토어의 현재 상태를 나타내는 속성입니다.
    var state: StateType { get set }
    
    /// 뷰(View) 또는 외부에서 액션을 스토어로 전달하는 공개된 진입점입니다.
    func send(_ action: ActionType) async
    /// 액션을 받아 프로세스 결과(OTProcessResult)를 반환하는 핵심 메서드입니다.
    /// 이 과정에서 비동기 작업이나 사이드 이펙트(네트워크 요청, 데이터베이스 접근 등)가 발생할 수 있습니다.
    /// 각 스토어 구현체에서 구체적인 로직을 정의해야 합니다.
    func process(_ action: ActionType) async -> OTProcessResult<ProcessType>
    /// 현재 상태와 주어진 프로세스를 기반으로 새로운 상태를 계산하는 순수 함수입니다.
    /// 이 함수는 오직 상태 업데이트만 담당하며, 사이드 이펙트를 발생시키지 않습니다.
    /// 각 스토어 구현체에서 구체적인 로직을 정의해야 합니다.
    func reduce(state: StateType, process: ProcessType) -> StateType
}

/// OTStore 프로토콜의 기본 구현을 제공합니다.
extension OTStore {
    
    /// 액션을 받아 처리하고 상태 업데이트를 트리거하는 핵심 메서드입니다.
    ///
    /// - Parameter action: 처리할 액션입니다.
    func send(_ action: ActionType) async {
        
        // 1. 'processStream' 헬퍼 함수를 호출하여 액션에 해당하는 프로세스 스트림을 얻습니다.
        let stream = self.processStream(action)
        
        // 2. 프로세스 스트림을 비동기적으로 반복 처리합니다.
        // 'processStream'에서 yield된 각 프로세스가 이 루프를 통해 하나씩 전달됩니다.
        for await process in stream {
            // 3. UI 업데이트는 항상 메인 액터(MainActor)에서 이루어져야 하기 때문에,
                // 'MainActor.run' 블록 내에서 상태를 업데이트합니다.
            await MainActor.run {
                self.state = self.reduce(state: self.state, process: process)
            }
        }
    }
}

/// 스토어의 내부 구현을 돕는 헬퍼 함수들을 포함하는 확장입니다.
private extension OTStore {
    
    /// 주어진 액션으로부터 프로세스의 비동기 스트림을 생성합니다.
    /// 이 스트림은 'process' 함수가 반환하는 'OTProcessResult'에 따라 단일, 여러 개 또는 0개의 프로세스를 방출합니다.
    ///
    /// - Parameter action: 스트림을 생성할 액션입니다.
    /// - Returns: ProcessType을 방출하는 AsyncStream입니다.
    func processStream(_ action: ActionType) -> AsyncStream<ProcessType> {
        
        // 'AsyncStream'을 생성하여 비동기적으로 프로세스를 방출할 수 있도록 합니다.
        return AsyncStream { continuation in
            
            // 새로운 Task를 생성하여 비동기 작업이 백그라운드에서 실행될 수 있도록 합니다.
            Task {
                // 'process' 함수를 비동기적으로 호출하여 'OTProcessResult'를 얻습니다.
                let result = await self.process(action)
                
                // 'process' 함수의 결과에 따라 스트림에 프로세스를 'yield'합니다.
                switch result {
                case let .single(process):
                    // 단일 프로세스인 경우, 해당 프로세스를 스트림에 방출합니다.
                    continuation.yield(process)
                case let .concat(processes):
                    // 여러 프로세스가 배열 형태로 온 경우, 배열의 각 프로세스를 순차적으로 스트림에 방출합니다.
                    for process in processes {
                        continuation.yield(process)
                    }
                case .none:
                    // 반환할 프로세스가 없는 경우, 아무것도 방출하지 않습니다.
                    break
                }
                
                // 모든 프로세스 방출이 완료되었음을 스트림에 알립니다.
                // 이는 'for await' 루프의 종료를 트리거합니다.
                continuation.finish()
            }
        }
    }
}
