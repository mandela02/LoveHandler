//
//  Constant.swift
//  LoveHandler
//
//  Created by LanNTH on 17/04/2021.
//

import Foundation

struct Constant {
    static let minDate = DefaultDateFormatter.date(from: "1900/1/1") ?? Date()
    static let maxDate = DefaultDateFormatter.date(from: "2079/12/31") ?? Date()
}
