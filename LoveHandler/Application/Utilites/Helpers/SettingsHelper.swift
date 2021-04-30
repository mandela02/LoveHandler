//
//  SettingsHelper.swift
//  LoveHandler
//
//  Created by LanNTH on 21/04/2021.
//

import Combine
import Foundation

struct SettingsHelper {
    static let relationshipStartDate = CurrentValueSubject<Date, Never>(Settings.relationshipStartDate.value)
    static let marryDate = CurrentValueSubject<Date, Never>( Settings.marryDate.value)
    static let isShowingBackgroundWave = CurrentValueSubject<Bool, Never>(Settings.isShowingBackgroundWave.value)
}
