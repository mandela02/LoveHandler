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
    static let weddingDate = CurrentValueSubject<Date, Never>(Settings.weddingDate.value)
    static let backgroundImage = CurrentValueSubject<Data?, Never>(Settings.background.value)
}
