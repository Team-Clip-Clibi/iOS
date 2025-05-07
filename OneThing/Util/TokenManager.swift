//
//  TokenManager.swift
//  OneThing
//
//  Created by 윤동주 on 4/4/25.
//

import Foundation

final class TokenManager {
    static let shared = TokenManager()
    
    private init() {}
    
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    
    var accessToken: String {
        get { UserDefaults.standard.string(forKey: accessTokenKey) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: accessTokenKey) }
    }
    
    var refreshToken: String {
        get { UserDefaults.standard.string(forKey: refreshTokenKey) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: refreshTokenKey) }
    }
    
    func clearTokens() {
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
        UserDefaults.standard.removeObject(forKey: refreshTokenKey)
    }
}
