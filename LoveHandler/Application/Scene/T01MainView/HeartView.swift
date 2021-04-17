//
//  HeartView.swift
//  LoveHandler
//
//  Created by LanNTH on 16/04/2021.
//

import UIKit
import Lottie
import WaveAnimationView

class HeartView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    deinit {
        wave?.stopAnimation()
    }
    
    private func initView() {
        animationInitial()
    }


    private var wave: WaveAnimationView?
    
    var progress: Float = 0.5 {
        didSet {
            wave?.setProgress(progress)
        }
    }
    
    private func animationInitial() {
        let heart = ImageNames.heart.image
        var colorImage = heart?.withRenderingMode(.alwaysTemplate)
        colorImage = colorImage?.tintColor(with: UIColor.white.withAlphaComponent(0.25))
        
        wave = WaveAnimationView(frame: self.bounds, color: UIColor.red.withAlphaComponent(0.5))
        wave?.startAnimation()
        wave?.frontColor = UIColor.red.withAlphaComponent(0.5)
        wave?.backColor = UIColor.red.withAlphaComponent(0.5)
        

        wave?.maskImage = heart
        
        let strokeView = UIImageView(frame: self.bounds)
        strokeView.image = colorImage
        strokeView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)

        if let wave = wave {
            self.addSubview(strokeView)
            self.addSubview(wave)
        }
    }
}
