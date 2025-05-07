//
//  UserDefaultsSessionStore.swift
//  OneThing
//
//  Created by 윤동주 on 5/2/25.
//

import Foundation

protocol SessionStoring {
    var socialId: String? { get set }
    var platform: String? { get set }
    var firebaseToken: String? { get set }
}

final class UserDefaultsSessionStore: SessionStoring {
    private let defaults = UserDefaults.standard

    private enum Key {
        static let socialId = "socialId"
        static let platform = "platform"
        static let firebaseToken = "firebaseToken"
    }

    var socialId: String? {
        get { defaults.string(forKey: Key.socialId) }
        set { defaults.set(newValue, forKey: Key.socialId) }
    }

    var platform: String? {
        get { defaults.string(forKey: Key.platform) }
        set { defaults.set(newValue, forKey: Key.platform) }
    }

    var firebaseToken: String? {
        get { defaults.string(forKey: Key.firebaseToken) }
        set { defaults.set(newValue, forKey: Key.firebaseToken) }
    }
}
