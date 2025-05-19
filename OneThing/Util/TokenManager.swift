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
    private let firebaseTokenKey = "firebaseToken"
    
    var accessToken: String {
        get { UserDefaults.standard.string(forKey: accessTokenKey) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: accessTokenKey) }
    }
    
    var refreshToken: String {
        get { UserDefaults.standard.string(forKey: refreshTokenKey) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: refreshTokenKey) }
    }
    
    var firebaseToken: String {
        get { UserDefaults.standard.string(forKey: firebaseTokenKey) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: firebaseTokenKey) }
    }
    
    func clearTokens() {
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
        UserDefaults.standard.removeObject(forKey: refreshTokenKey)
    }
}
