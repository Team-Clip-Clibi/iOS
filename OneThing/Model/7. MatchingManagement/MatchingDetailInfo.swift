//
//  MatchingDetailInfo.swift
//  OneThing
//
//  Created by 오현식 on 7/21/25.
//

import Foundation

struct MatchingDetailInfo: Equatable {
    let matchingId: String
    let meetingTime: Date
    let matchingStatus: MatchingStatus
    let matchingType: MatchingType
    let myOneThingContent: String
    let applicationInfo: ApplicationInfo
    let myMatchingInfo: MyMatchingInfo
    let paymentInfo: PaymentInfo
}

extension MatchingDetailInfo: Codable { }
