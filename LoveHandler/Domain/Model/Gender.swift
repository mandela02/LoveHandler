//
//  Gender.swift
//  LoveHandler
//
//  Created by LanNTH on 17/04/2021.
//

import UIKit

enum Gender: Int, CaseIterable, EnumName {
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
    
    var defaultImage: UIImage {
        switch self {
        case .male:
            return ImageNames.man.image ?? UIImage()
        case .female:
            return ImageNames.woman.image ?? UIImage()
        default:
            return ImageNames.bigender.image ?? UIImage()
        }
    }
    
    func getName() -> String {
        return "\(symbol) \(name)"
    }
    
    static func getGender(from index: Int) -> Gender {
        return allCases[safe: index] ?? .female
    }
}
