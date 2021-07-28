//
//  HeartView.swift
//  LoveHandler
//
//  Created by LanNTH on 16/04/2021.
//

import UIKit
import Lottie
import WaveAnimationView

class HeartView: BaseView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        wave?.stopAnimation()
    }
    
    private var wave: WaveAnimationView?
    
    var progress: Float = 0 {
        didSet {
            wave?.setProgress(progress)
        }
    }
    
    override func layoutSubviews() {
        animationInitial()
    }
    
    override func setupTheme() {
        wave?.frontColor = Theme.current.heartColor.heartBackground.withAlphaComponent(0.5)
        wave?.backColor = Theme.current.heartColor.heartBackground
    }
    
    private func animationInitial() {
        if wave != nil { return }
        
        let heart = ImageNames.heart.image
        var colorImage = heart?.withRenderingMode(.alwaysTemplate)
        colorImage = colorImage?.tintColor(with: UIColor.white.withAlphaComponent(0.25))
        
        wave = WaveAnimationView(frame: self.bounds,
                                 frontColor: Theme.current.heartColor.heartBackground.withAlphaComponent(0.5),
                                 backColor: Theme.current.heartColor.heartBackground)
        
        guard let wave = wave else { return }
        
        let strokeView = UIImageView(frame: self.bounds)
        strokeView.image = colorImage
        strokeView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)

        self.addSubview(wave)
        
        wave.translatesAutoresizingMaskIntoConstraints = false
        wave.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        wave.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        wave.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        wave.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.addSubview(strokeView)

        strokeView.translatesAutoresizingMaskIntoConstraints = false
        strokeView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        strokeView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        strokeView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        strokeView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        wave.startAnimation()
        wave.maskImage = heart
    }
}
