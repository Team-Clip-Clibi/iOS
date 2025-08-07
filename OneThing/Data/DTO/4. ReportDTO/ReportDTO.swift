//
//  ReportDTO.swift
//  OneThing
//
//  Created by 윤동주 on 5/3/25.
//

import Foundation

struct ReportDTO: Codable {
    let content: String
    let reportCategory: ReportCategory
}

enum ReportCategory: String, Codable {
    case slang    = "SLANG"
    case crime    = "CRIME"
    case sex      = "SEX"
    case `false`  = "FALSE"
    case abusing  = "ABUSING"
    case etc      = "ETC"
}
