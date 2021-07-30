//
//  NumberDisplayView.swift
//  LoveHandler
//
//  Created by LanNTH on 04/07/2021.
//

import UIKit

class NumberDisplayView: BaseView, NibLoadable {
    
    @IBOutlet weak var displayLabel: BaseLabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var heartImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
        
    override func setupTheme() {
        displayLabel.textColor = Theme.current.heartColor.heartText
        titleLabel.textColor = Theme.current.heartColor.heartText
        heartImageView.image = "heart_container".image?.tintColor(with: Theme.current.heartColor.heartBackground)
    }
    
    func setupLabel(with content: String, title: String? = nil, size: CGFloat = 20) {
        displayLabel.text = content
        
        displayLabel.setFontSize(size)
        
        titleLabel.text = title
        titleLabel.isHidden = title == nil
        titleHeightConstraint.constant = title == nil ? 0 : 30
    }
}
