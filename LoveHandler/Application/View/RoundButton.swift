//
//  RoundButton.swift
//  LoveHandler
//
//  Created by LanNTH on 30/04/2021.
//

import UIKit

class RoundButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
}
