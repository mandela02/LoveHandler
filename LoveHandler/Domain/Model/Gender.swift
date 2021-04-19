//
//  Gender.swift
//  LoveHandler
//
//  Created by LanNTH on 17/04/2021.
//

import Foundation

enum Gender: CaseIterable, EnumName {
    case female
    case male
    case intersexual
    case neutral
    
    var symbol: String {
        switch self {
        case .female:
            return "♀"
        case .male:
            return "♂"
        case .intersexual:
            return "⚥"
        case .neutral:
            return "⚲"
        }
    }
    
    var name: String {
        switch self {
        case .female:
            return LocalizedString.female
        case .male:
            return LocalizedString.male
        case .intersexual:
            return LocalizedString.intersexual
        case .neutral:
            return LocalizedString.neutral
        }
    }
    
    func getName() -> String {
        return "\(symbol) \(name)"
    }
}
