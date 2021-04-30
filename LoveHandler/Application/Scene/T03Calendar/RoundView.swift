//
//  RoundView.swift
//  LoveHandler
//
//  Created by LanNTH on 24/04/2021.
//

import UIKit

@IBDesignable
class RoundView: UIView {

    @IBInspectable var isRound: Bool = false

    override func layoutSubviews() {
        if isRound {
            self.layer.cornerRadius = self.height / 2
        }
    }
}
