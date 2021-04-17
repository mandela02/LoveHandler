//
//  Gender.swift
//  LoveHandler
//
//  Created by LanNTH on 17/04/2021.
//

import Foundation

enum Gender {
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
            return "Nữ"
        case .male:
            return "Nam"
        case .intersexual:
            return "Dị tính"
        case .neutral:
            return "Trung tính"
        }
    }
}
