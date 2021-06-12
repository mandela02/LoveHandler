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
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
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
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurEffectView.frame = textContentView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textContentView.addSubview(blurEffectView)
        textContentView.bringSubviewToFront(titleLabel)
    }
    
    func setupContent(memory: CDMemory) {
        if let data = memory.image,
        let image = UIImage(data: data) {
            imageView.image = image
        }
        
        dateLabel.text = Date(timeIntervalSince1970: TimeInterval(memory.displayedDate)).dayMonthYearString
        titleLabel.text = memory.title
    }
}
