//
//  SettingsHelper.swift
//  LoveHandler
//
//  Created by LanNTH on 21/04/2021.
//

import RxSwift
import RxCocoa

struct SettingsHelper {
    static let relationshipStartDate = BehaviorRelay<Date>(value: Settings.relationshipStartDate.value)
    static let marryDate = BehaviorRelay<Date>(value: Settings.marryDate.value)
    static let isShowingBackgroundWave = BehaviorRelay<Bool>(value: Settings.isShowingBackgroundWave.value)
}
