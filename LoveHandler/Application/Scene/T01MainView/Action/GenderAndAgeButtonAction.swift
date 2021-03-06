//
//  GenderButtonAction.swift
//  LoveHandler
//
//  Created by LanNTH on 18/04/2021.
//

import Foundation

enum GenderAndAgeButtonAction: CaseIterable, EnumName {
    case chooseGender
    case chooseDateOfBirth
    case chooseColor
    case chooseTextColor
    
    func getName() -> String {
        switch self {
        case .chooseGender:
            return LocalizedString.t01GenderOptionTitle
        case .chooseDateOfBirth:
            return LocalizedString.t01BirthDayOptionTitle
        case .chooseColor:
            return LocalizedString.t01ColorOptionTitle
        case .chooseTextColor:
            return LocalizedString.t01TextColorOptionTitle
        }
    }
}
