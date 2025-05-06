//
//  NetworkError.swift
//  OneThing
//
//  Created by 윤동주 on 3/15/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidHttpStatusCode(code: Int)
    case decodeError
    case urlRequestFailed(description: String)
    case invalidIdToken
    case invalidSocialId
    case invalidFCMToken
}
