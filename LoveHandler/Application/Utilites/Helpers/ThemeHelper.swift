//
//  ThemeHelper.swift
//  LoveHandler
//
//  Created by LanNTH on 24/07/2021.
//

import UIKit

enum Theme: CaseIterable {
    case pink
    case monotoneBlack
    case freshOrange
    case fireRed
    
    private var themeColor: Color {
        switch self {
        case .pink:
            return ThemeColor.purePink
        case .monotoneBlack:
            return ThemeColor.monoToneBlack
        case .freshOrange:
            return ThemeColor.freshOrange
        case .fireRed:
            return ThemeColor.fireRed

        }
    }
    
    static var current: Color {
        return Theme.allCases[safe: Settings.themeId.value]?.themeColor ?? Theme.pink.themeColor
    }
    
    static func post(themeId: Int) {
        Settings.themeId.value = themeId
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Strings.themeChangedObserver), object: nil)
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
        var iconColor: UIColor
    }
    
    struct CommonColor {
        var textColor: UIColor
    }
    
    struct HeartColor {
        var heartBackground: UIColor
        var heartText: UIColor
    }
        
    let navigationColor: NavigationColor
    let tableViewColor: TableViewColor
    let searchBarColor: SearchBarColor
    let buttonColor: ButtonColor
    let commonColor: CommonColor
    let heartColor: HeartColor
}

struct ThemeColor {
    typealias NavigationColor           = Color.NavigationColor
    typealias TableViewColor            = Color.TableViewColor
    typealias SearchBarColor            = Color.SearchBarColor
    typealias ButtonColor               = Color.ButtonColor
    typealias CommonColor               = Color.CommonColor
    typealias HeartColor               = Color.HeartColor

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
                                                          tintColor: UIColor(hexString: "FFFFFF"),
                                                          iconColor: UIColor(hexString: "FFFFFF")),
                                 commonColor: CommonColor(textColor: UIColor(hexString: "FFFFFF")),
                                 heartColor: HeartColor(heartBackground: UIColor(hexString: "FFA596"),
                                                        heartText: UIColor(hexString: "FFFFFF")))
    static let monoToneBlack = Color(navigationColor: NavigationColor(button: UIColor(hexString: "FFFFFF"),
                                                                 title: UIColor(hexString: "FFFFFF"),
                                                                 background: UIColor(hexString: "17191A"),
                                                                 barStyle: .black),
                                tableViewColor: TableViewColor(background: UIColor(hexString: "000000"),
                                                               cellBackground: UIColor(hexString: "17191A"),
                                                               text: UIColor(hexString: "FFFFFF"),
                                                               indicatorStyle: .white),
                                searchBarColor: SearchBarColor(backgroundColor: UIColor(hexString: "FFFFFF"),
                                                               textColor: UIColor(hexString: "000000"),
                                                               tintColor: UIColor(hexString: "FFFFFF")),
                                 buttonColor: ButtonColor(backgroundColor: UIColor(hexString: "17191A"),
                                                          tintColor: UIColor(hexString: "FFFFFF"),
                                                          iconColor: UIColor(hexString: "000000")),
                                 commonColor: CommonColor(textColor: UIColor(hexString: "000000")),
                                 heartColor: HeartColor(heartBackground: UIColor(hexString: "17191A"),
                                                        heartText: UIColor(hexString: "FFFFFF")))
    
    static let freshOrange = Color(navigationColor: NavigationColor(button: UIColor(hexString: "FFFFFF"),
                                                                 title: UIColor(hexString: "FFFFFF"),
                                                                 background: UIColor(hexString: "FFA936"),
                                                                 barStyle: .black),
                                tableViewColor: TableViewColor(background: UIColor(hexString: "FFFCEE"),
                                                               cellBackground: UIColor(hexString: "FFFFFF"),
                                                               text: UIColor(hexString: "767676"),
                                                               indicatorStyle: .white),
                                searchBarColor: SearchBarColor(backgroundColor: UIColor(hexString: "FFFFFF"),
                                                               textColor: UIColor(hexString: "767676"),
                                                               tintColor: UIColor(hexString: "FFFFFF")),
                                 buttonColor: ButtonColor(backgroundColor: UIColor(hexString: "FFA936"),
                                                          tintColor: UIColor(hexString: "FFFFFF"),
                                                          iconColor: UIColor(hexString: "FFFFFF")),
                                 commonColor: CommonColor(textColor: UIColor(hexString: "FFFFFF")),
                                 heartColor: HeartColor(heartBackground: UIColor(hexString: "FFA936"),
                                                        heartText: UIColor(hexString: "FFFFFF")))
    
    static let fireRed = Color(navigationColor: NavigationColor(button: UIColor(hexString: "FFFFFF"),
                                                                 title: UIColor(hexString: "FFFFFF"),
                                                                 background: UIColor(hexString: "FF0000"),
                                                                 barStyle: .black),
                                tableViewColor: TableViewColor(background: UIColor(hexString: "FFFCEE"),
                                                               cellBackground: UIColor(hexString: "FFFFFF"),
                                                               text: UIColor(hexString: "000000"),
                                                               indicatorStyle: .white),
                                searchBarColor: SearchBarColor(backgroundColor: UIColor(hexString: "FFFFFF"),
                                                               textColor: UIColor(hexString: "FF0000"),
                                                               tintColor: UIColor(hexString: "FFFFFF")),
                                 buttonColor: ButtonColor(backgroundColor: UIColor(hexString: "FF0000"),
                                                          tintColor: UIColor(hexString: "FFFFFF"),
                                                          iconColor: UIColor(hexString: "FFFFFF")),
                                 commonColor: CommonColor(textColor: UIColor(hexString: "FFFFFF")),
                                 heartColor: HeartColor(heartBackground: UIColor(hexString: "FF0000"),
                                                        heartText: UIColor(hexString: "FFFFFF")))
}
