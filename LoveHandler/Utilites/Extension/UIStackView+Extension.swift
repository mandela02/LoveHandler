//
//  UIStackView+Extension.swift
//  LoveHandler
//
//  Created by LanNTH on 16/04/2021.
//

import UIKit

extension UIStackView {
    func removeAllArrangedSubviews() {
        while arrangedSubviews.count > 0 {
            arrangedSubviews.first?.removeFromSuperview()
        }
    }
    
    func addBackground(color: UIColor, radiusSize: CGFloat = 10) {
        subviews.forEach { if $0.tag == 0 { $0.removeFromSuperview() } }
        let subView = UIView(frame: bounds)
        
        subView.layer.cornerRadius = radiusSize
        subView.layer.masksToBounds = true
        subView.clipsToBounds = true
        
        subView.tag = 0
        
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
