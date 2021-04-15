//
//  Mirror+Extension.swift
//  LoveHandler
//
//  Created by LanNTH on 16/04/2021.
//

import Foundation

extension Mirror {
    static func isOptional(any: Any) -> Bool {
        guard let style = Mirror(reflecting: any).displayStyle,
            style == .optional else { return false }
        return true
    }
}
