//
//  NSObject+Extension.swift
//  LoveHandler
//
//  Created by LanNTH on 16/04/2021.
//

import UIKit

extension NSObject {
    @nonobjc class var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    var className: String {
        return type(of: self).className
    }
}
