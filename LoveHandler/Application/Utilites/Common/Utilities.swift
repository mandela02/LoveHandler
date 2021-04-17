//
//  Utilities.swift
//  LoveHandler
//
//  Created by LanNTH on 16/04/2021.
//

import UIKit

struct Utilities {
    static func getWindowSize() -> CGSize {
        return getWindowBound().size
    }
    
    static func getWindowBound() -> CGRect {
        guard
            let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let windowBound = appDelegate.window?.bounds
        else {
            return .zero
        }
        
        return windowBound
    }
    
    static var isIpad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
