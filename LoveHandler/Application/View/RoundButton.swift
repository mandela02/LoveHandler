//
//  RoundButton.swift
//  LoveHandler
//
//  Created by LanNTH on 30/04/2021.
//

import UIKit

class RoundButton: UIButton {
    override init(frame: CGRect) {
        // 1. setup any properties here
        // 2. call super.init(frame:)
        super.init(frame: frame)
        // 3. Setup view from .xib file
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        // 3. Setup view from .xib file
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
}
