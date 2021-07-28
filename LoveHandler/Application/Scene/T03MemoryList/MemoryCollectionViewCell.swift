//
//  MemoryCollectionViewCell.swift
//  LoveHandler
//
//  Created by LanNTH on 11/06/2021.
//

import UIKit

class MemoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textContentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateContainerView: UIStackView!

    var isAnimated = false
    
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        dateLabel.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textContentView.backgroundColor = UIColor.clear
        dateLabel.textColor = UIColor.white
        titleLabel.textColor = UIColor.white
        holderView.viewCornerRadius = 10
        applyBlurEffect()
    }
    
    func applyBlurEffect() {
        visualEffectView.backgroundColor = Theme.current.navigationColor.background.withAlphaComponent(0.25)
        visualEffectView.frame = textContentView.bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        visualEffectView.alpha = 0.9
        textContentView.addSubview(visualEffectView)
        textContentView.bringSubviewToFront(titleLabel)
    }
    
    func setupContent(memory: CDMemory) {
        self.backgroundColor = Theme.current.tableViewColor.background
        imageView.backgroundColor = UIColor.clear
        
        if let data = memory.image,
        let image = UIImage(data: data) {
            imageView.image = image
        }
        
        dateLabel.text = Date(timeIntervalSince1970: TimeInterval(memory.displayedDate)).dayMonthYearDayOfWeekString
        titleLabel.text = memory.title
        
        hero.isEnabled = true
        self.hero.id = memory.id?.uuidString ?? "" + "-image"
        self.hero.modifiers  = [.cornerRadius(10), .forceAnimate]
    }
}
