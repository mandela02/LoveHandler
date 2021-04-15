//
//  UITableViewCell+Extension.swift
//  LoveHandler
//
//  Created by LanNTH on 16/04/2021.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var reuseID: String {
        return className
    }
}

@IBDesignable extension UITableViewCell {
    @IBInspectable var selectedColor: UIColor? {
        get {
            return selectedBackgroundView?.backgroundColor
        }
        
        set {
            if let color = newValue {
                selectedBackgroundView = UIView()
                selectedBackgroundView!.backgroundColor = color
            } else {
                selectedBackgroundView = nil
            }
        }
    }
}
