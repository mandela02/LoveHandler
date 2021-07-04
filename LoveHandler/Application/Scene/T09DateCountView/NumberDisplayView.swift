//
//  NumberDisplayView.swift
//  LoveHandler
//
//  Created by LanNTH on 04/07/2021.
//

import UIKit

class NumberDisplayView: UIView, NibLoadable {
    
    @IBOutlet weak var displayLabel: BaseLabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
        setupView()
    }
        
    private func setupView() {
        displayLabel.textColor = UIColor.white
        titleLabel.textColor = UIColor.white
    }
    
    func setupLabel(with content: String, title: String? = nil, size: CGFloat = 20) {
        displayLabel.text = content
        
        displayLabel.setFontSize(size)
        
        titleLabel.text = title
        titleLabel.isHidden = title == nil
        titleHeightConstraint.constant = title == nil ? 0 : 30
    }
}
