//
//  Strings.swift
//  LoveHandler
//
//  Created by LanNTH on 17/04/2021.
//

import Foundation

enum LanguageCode: String, CaseIterable {
    case english = "en-US"
    case vietnamese = "vi"
    
    var name: String {
        switch self {
        case .english:
            return "English"
        case .vietnamese:
            return "Tiếng Việt"
        }
    }
            
    static func getLanguageCode(from index: Int) -> LanguageCode {
        return allCases.indices.contains(index) ? allCases[index] : .english
    }
    
}

struct Strings {
    static private let preferredLanguages = NSLocale.preferredLanguages
    
    static var languageCodeDevice: String {
        guard
            let currentLanguage = preferredLanguages.first,
            let languageCode = LanguageCode.allCases.filter({ currentLanguage.lowercased().contains($0.rawValue.lowercased()) }).first
        else { return LanguageCode.english.rawValue }
        return languageCode.rawValue
    }
    
    
    static var localeIdentifier: String {
        return Settings.appLanguage.value
    }
    
    static var languageChangedObserver = "languageChangedObserver"
}
