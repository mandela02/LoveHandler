//
//  BaseLabel.swift
//  LoveHandler
//
//  Created by LanNTH on 17/04/2021.
//

import UIKit

class BaseLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        self.textColor = Theme.current.commonColor.textColor
        self.font = Biotif.regular(size: getFontSize()).font
    }
}
