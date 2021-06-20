//
//  UIDevice+Extension.swift
//  LoveHandler
//
//  Created by LanNTH on 17/06/2021.
//

import UIKit
import DeviceKit

extension UIDevice {
    var isIphoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    
    var isIphonePlus: Bool {
        return Device.current.isOneOf([.iPhone6Plus,
                                       .iPhone6sPlus,
                                       .iPhone7Plus,
                                       .iPhone8Plus,
                                       .simulator(.iPhone6Plus),
                                       .simulator(.iPhone6sPlus),
                                       .simulator(.iPhone7Plus),
                                       .simulator(.iPhone8Plus)])
    }
    
    var isSmallIphone: Bool {
        return Device.current.isOneOf([.iPhone4,
                                       .iPhone4s,
                                       .iPhone5,
                                       .iPhone5s,
                                       .iPhoneSE,
                                       .simulator(.iPhone4),
                                       .simulator(.iPhone4s),
                                       .simulator(.iPhone5),
                                       .simulator(.iPhone5s),
                                       .simulator(.iPhoneSE)])
    }
    
    var isIpad: Bool {
        return model == "iPad"
    }
    
    var isDarkMode: Bool {
        guard #available(iOS 12.0, *), UIScreen.main.traitCollection.userInterfaceStyle == .dark else {
            return false
        }
        return true
    }
}
