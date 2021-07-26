//
//  ThemeHelper.swift
//  LoveHandler
//
//  Created by LanNTH on 24/07/2021.
//

import UIKit

enum Theme {
    case pink
    case monotoneBlack
    
    private var themeColor: Color {
        switch self {
        case .pink:
            return ThemeColor.purePink
        default:
            return ThemeColor.purePink
        }
    }
    
    static var current: Color {
        return Theme.pink.themeColor
    }
}

struct Color {
    struct NavigationColor {
        var button: UIColor
        var title: UIColor
        var background: UIColor
        var barStyle: UIBarStyle
    }
    
    struct TableViewColor {
        var background: UIColor
        var cellBackground: UIColor
        var text: UIColor
        var indicatorStyle: UIScrollView.IndicatorStyle
    }
    
    struct SearchBarColor {
        var backgroundColor: UIColor
        var textColor: UIColor
        var tintColor: UIColor
    }
    
    struct ButtonColor {
        var backgroundColor: UIColor
        var tintColor: UIColor
    }
        
    let navigationColor: NavigationColor
    let tableViewColor: TableViewColor
    let searchBarColor: SearchBarColor
    let buttonColor: ButtonColor
}

struct ThemeColor {
    typealias NavigationColor           = Color.NavigationColor
    typealias TableViewColor            = Color.TableViewColor
    typealias SearchBarColor            = Color.SearchBarColor
    typealias ButtonColor               = Color.ButtonColor

    static let purePink = Color(navigationColor: NavigationColor(button: UIColor(hexString: "FFFFFF"),
                                                                 title: UIColor(hexString: "FFFFFF"),
                                                                 background: UIColor(hexString: "FFA596"),
                                                                 barStyle: .black),
                                tableViewColor: TableViewColor(background: UIColor(hexString: "FFF8F8"),
                                                               cellBackground: UIColor(hexString: "FFFFFF"),
                                                               text: UIColor(hexString: "767676"),
                                                               indicatorStyle: .black),
                                searchBarColor: SearchBarColor(backgroundColor: UIColor(hexString: "FFFFFF"),
                                                               textColor: UIColor(hexString: "767676"),
                                                               tintColor: UIColor(hexString: "767676")),
                                 buttonColor: ButtonColor(backgroundColor: UIColor(hexString: "FFA596"),
                                                          tintColor: UIColor(hexString: "FFFFFF")))
}
