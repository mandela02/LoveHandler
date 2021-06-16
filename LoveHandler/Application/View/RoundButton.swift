//
//  RoundButton.swift
//  LoveHandler
//
//  Created by LanNTH on 30/04/2021.
//

import UIKit

class RoundButton: UIButton {
    @IBInspectable var isShadowSet: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private var shadowLayer: CAShapeLayer!

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
        
        if isShadowSet {
            if shadowLayer == nil {
                shadowLayer = CAShapeLayer()
                shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
                shadowLayer.fillColor = self.backgroundColor?.cgColor

                shadowLayer.shadowColor = UIColor.darkGray.cgColor
                shadowLayer.shadowPath = shadowLayer.path
                shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
                shadowLayer.shadowOpacity = 0.8
                shadowLayer.shadowRadius = 2

                layer.insertSublayer(shadowLayer, at: 0)
            }
        }
    }
}
