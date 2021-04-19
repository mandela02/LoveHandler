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
    case relationshipStartDate
    case marryDate
}

struct Settings {
    static var appLanguage = UserDefault<String>(key: .appLanguage,
                                                 defaultValue: LanguageCode.vietnamese.rawValue)
    static var relationshipStartDate = UserDefault<Date>(key: .relationshipStartDate,
                                                         defaultValue: DefaultDateFormatter.date(from: "2020/7/5") ?? Date())
    static var marryDate = UserDefault<Date>(key: .marryDate,
                                               defaultValue: Date().nextYear)
}
