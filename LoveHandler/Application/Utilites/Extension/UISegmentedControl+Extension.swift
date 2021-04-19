//
//  UISegmentedControl+Extension.swift
//  LoveHandler
//
//  Created by LanNTH on 16/04/2021.
//

import UIKit

extension UISegmentedControl {
    func selectedSegmentTitleColor(_ color: UIColor) {
        var attributes = self.titleTextAttributes(for: .selected) ?? [:]
        attributes[.foregroundColor] = color
        self.setTitleTextAttributes(attributes, for: .selected)
    }
    func unselectedSegmentTitleColor(_ color: UIColor) {
        var attributes = self.titleTextAttributes(for: .normal) ?? [:]
        attributes[.foregroundColor] = color
        self.setTitleTextAttributes(attributes, for: .normal)
    }
}
