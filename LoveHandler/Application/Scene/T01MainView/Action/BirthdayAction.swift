//
//  birthdayAction.swift
//  LoveHandler
//
//  Created by LanNTH on 20/07/2021.
//

import Foundation

enum BirthdayAction: CaseIterable, EnumName {
    case chooseBirthDay
    case chooseColor
    case chooseTextColor
    
    func getName() -> String {
        switch self {
        case .chooseBirthDay:
            return LocalizedString.t01BirthDayOptionTitle
        case .chooseColor:
            return LocalizedString.t01ColorOptionTitle
        case .chooseTextColor:
            return LocalizedString.t01TextColorOptionTitle
        }
    }
}
