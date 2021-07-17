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

struct HeroIdentifier {
    static let addButtonIdentifier = "addButton"
}


struct AppConfig {
    #if DEBUG
    static let adsIDs = "ca-app-pub-3940256099942544/2934735716"
    #elseif RELEASE
    static let adsIDs = "ca-app-pub-7813435127631546/8530945451"
    #else
    static let adsIDs = "ca-app-pub-3940256099942544/2934735716"
    #endif
    
}
