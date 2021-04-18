//
//  DefaultDateFormatter.swift
//  LoveHandler
//
//  Created by LanNTH on 17/04/2021.
//

import Foundation

struct DefaultDateFormatter {
    static private let dateFormatter = { () -> DateFormatter in
        let dateFormatter = DateFormatter(dateFormat: "y/M/d")
        dateFormatter.calendar = .gregorian
        return dateFormatter
    }()
    
    static func date(from string: String?) -> Date? {
        guard let string = string else { return nil }
        return dateFormatter.date(from: string)
    }
    
    static func string(from date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    static func formatDate(from date: Date) -> Date? {
        let dateString = string(from: date)
        return dateFormatter.date(from: dateString)
    }
    
    static func date(from string: String, dateFormat: String) -> Date? {
        let dateFormatter = DateFormatter(dateFormat: dateFormat)
        return dateFormatter.date(from: string)
    }
    
    static func string(from date: Date, dateFormat: String) -> String {
        let dateFormatter = DateFormatter(dateFormat: dateFormat)
        return dateFormatter.string(from: date)
    }
}
