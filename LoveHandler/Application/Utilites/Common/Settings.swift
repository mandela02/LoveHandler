//
//  Settings.swift
//  LoveHandler
//
//  Created by LanNTH on 17/04/2021.
//

import Foundation

struct UserDefault<T> {
    let key: String
    let defaultValue: T

    init(key: Keys, defaultValue: T) {
        self.key = key.rawValue
        self.defaultValue = defaultValue
    }

    var value: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

enum Keys: String {
    case appLanguage
}

struct Settings {
    static var appLanguage = UserDefault<String>(key: .appLanguage,
                                                 defaultValue: LanguageCode.vietnamese.rawValue)
}