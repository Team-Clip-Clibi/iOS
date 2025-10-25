//
//  MatchingStatus.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

enum MatchingStatus: String {
    /*
        APPLIED     : 매칭이 신청된 상태
        CONFIRMED   : 매칭이 확정된 상태
        COMPLETED   : 모임이 종료된 상태 (후기 작성 연관 X)
        CANCELED    : 매칭을 취소한 상태
     */
    case applied    = "APPLIED"
    case confirmed  = "CONFIRMED"
    case completed  = "COMPLETED"
    case canceled   = "CANCELED"
    case noShow     = "NO_SHOW"
}

extension MatchingStatus: Codable { }
